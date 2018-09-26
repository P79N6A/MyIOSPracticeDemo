
#import "GLiveThreadLogger.h"
#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <sys/types.h>
#include <limits.h>
#include <string.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>

#pragma -mark DEFINE MACRO FOR DIFFERENT CPU ARCHITECTURE
#if defined(__arm64__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(3UL))
#define THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define THREAD_STATE ARM_THREAD_STATE64
#define FRAME_POINTER __fp
#define STACK_POINTER __sp
#define INSTRUCTION_ADDRESS __pc

#elif defined(__arm__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(1UL))
#define THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define THREAD_STATE ARM_THREAD_STATE
#define FRAME_POINTER __r[7]
#define STACK_POINTER __sp
#define INSTRUCTION_ADDRESS __pc

#elif defined(__x86_64__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define THREAD_STATE x86_THREAD_STATE64
#define FRAME_POINTER __rbp
#define STACK_POINTER __rsp
#define INSTRUCTION_ADDRESS __rip

#elif defined(__i386__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define THREAD_STATE x86_THREAD_STATE32
#define FRAME_POINTER __ebp
#define STACK_POINTER __esp
#define INSTRUCTION_ADDRESS __eip

#endif

#define CALL_INSTRUCTION_FROM_RETURN_ADDRESS(A) (DETAG_INSTRUCTION_ADDRESS((A)) - 1)

#if defined(__LP64__)
#define TRACE_FMT         "%-4d%-31s 0x%016lx %s + %lu"
#define POINTER_FMT       "0x%016lx"
#define POINTER_SHORT_FMT "0x%lx"
#define NLIST struct nlist_64
#else
#define TRACE_FMT         "%-4d%-31s 0x%08lx %s + %lu"
#define POINTER_FMT       "0x%08lx"
#define POINTER_SHORT_FMT "0x%lx"
#define NLIST struct nlist
#endif

typedef struct TagGLiveStackFrameEntry
{
    const struct StackFrameEntry *const previous;
    const uintptr_t return_address;
} GLiveStackFrameEntry;

@implementation GLiveThreadLogger
{
    mach_port_t _current_thread_id;
    thread_act_array_t _threads;
    mach_msg_type_number_t _thread_count;
}

+ (instancetype)shareInstance
{
    static GLiveThreadLogger* g_sharedInstance = nil;
    static dispatch_once_t once_token;
    _dispatch_once(&once_token, ^{
        g_sharedInstance = [[GLiveThreadLogger alloc] init];
    });
    return g_sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self prepare];
    }
    return self;
}

- (NSString *)logOfAllThread
{
    [self loadAllThreads];
    if (_thread_count == 0) {
        return @"";
    }
    NSMutableString *resultStr = [NSMutableString new];
    NSMutableArray *resultArray = [NSMutableArray new];
    [resultStr appendString:@"(\\n    "];
    [resultArray addObject:@"\"Deadlock may happend.\""];
    [resultArray addObject:[NSString stringWithFormat:@"\"current time : %.06f\"", [[NSDate date] timeIntervalSince1970]]];
    for (int i = 0; i < _thread_count; i++) {
        if (_threads[i] != _current_thread_id) {
            [resultArray addObject:[NSString stringWithFormat:@"\"Thread %d:\"", _threads[i]]];
            NSArray *backtraceArray = [self backtraceAddressOfThread:_threads[i]];
            [resultArray addObjectsFromArray:backtraceArray];
        }
    }
    [resultStr appendString:[resultArray componentsJoinedByString:@",\\n    "]];
    [resultStr appendString:@"\\n)"];
    return resultStr;
}

- (NSString *)logOfAllThreadUsage
{
    
    return [[self getThreadsCPUUsage] componentsJoinedByString:@"||"];
}

- (NSArray *)getThreadsStack
{
    [self loadAllThreads];
    if (_thread_count == 0) {
        return nil;
    }
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int i = 0; i < _thread_count; i++) {
        if (_threads[i] != _current_thread_id) {
            [resultArray addObject:[self backtraceAddressOfThread:_threads[i]]];
        }
    }
    return resultArray;
}

- (NSArray *)getThreadsCPUUsage
{
    [self loadAllThreads];
    NSMutableArray *usageArray = [NSMutableArray new];
    for (int i = 0; i < _thread_count; i++) {
        if (_current_thread_id != _threads[i]) {
            [usageArray addObject:[self basicInfoOfThread:_threads[i]]];
        }
    }
    return [usageArray copy];
}

-(NSString*) basicInfoOfThread:(thread_t) thread
{
    NSMutableString *resultString = [NSMutableString new];
    kern_return_t error;
    mach_msg_type_number_t count;
    thread_basic_info_t thi;
    thread_basic_info_data_t thi_data;
    thi = &thi_data;
    count = THREAD_BASIC_INFO_COUNT;
    error = thread_info(thread, THREAD_BASIC_INFO, (thread_info_t)thi, &count);
    if (error != KERN_SUCCESS) {
        [resultString appendFormat:@"Fail to get basic information about thread: %u", thread];
        return [resultString copy];
    }
    if ((thi->flags & TH_FLAGS_IDLE) == 0) {
        [resultString appendFormat:@"%d: %f%%", thread, thi->cpu_usage / (float)TH_USAGE_SCALE * 100.0];
    }
    return [resultString copy];
}

// 获取堆栈中每一帧的模块名，模块地址和当前指令地址，不查符号表，通过日志还原
-(NSArray*) backtraceAddressOfThread: (thread_t) thread
{
    uintptr_t backtraceBuffer[50];
    int i = 0;
    NSMutableArray *resultArray = [NSMutableArray new];
    
    _STRUCT_MCONTEXT machineContext;
    if (![self fillThreadStateIntoMachineContext:thread witchMachContext:&machineContext]) {
        [resultArray addObject:[NSString stringWithFormat:@"Fail to get backtrace about thread: %u", thread]];
        return [resultArray copy];
    }
    
    
    const uintptr_t instructionAddress = [self mach_instructionAddress:&machineContext];
    
    if (instructionAddress == 0) {
        [resultArray addObject:@"Fail to get instruction address"];
        return [resultArray copy];
    } else {
        backtraceBuffer[i++] = instructionAddress;
    }
    
    uintptr_t linkRegister = [self mach_linkRegister:&machineContext];
    if (linkRegister) {
        backtraceBuffer[i] = linkRegister;
        i++;
    }
    
    GLiveStackFrameEntry frame = {0};
    
    const uintptr_t framePtr = [self mach_framePointer:&machineContext];
    if (framePtr == 0 ||
        [self mach_copyMem:framePtr withDst:&frame withNumBytes:sizeof(frame)] != KERN_SUCCESS) {
        [resultArray addObject:@"Fail to get frame pointer"];
        return [resultArray copy];
    }
    
    for (; i < 50; i++) {
        backtraceBuffer[i] = frame.return_address;
        if (backtraceBuffer[i] == 0 || frame.previous == 0 ||
            [self mach_copyMem:framePtr withDst:&frame withNumBytes:sizeof(frame)] != KERN_SUCCESS) {
            break;
        }
    }
    int backtraceLength = i;
    Dl_info symbolicated[backtraceLength];
    [self symbolicate:backtraceBuffer withSymbolsBuf:symbolicated withNumEntries:backtraceLength withSkippedEntries:0];
    for (int i = 0; i < backtraceLength; ++i) {
        
        [resultArray addObject:[NSString stringWithFormat:@"\"%d %@\"", i + 1, [self logBacktraceEntry:i withAddress:backtraceBuffer[i] withDlInfo:&symbolicated[i]]]];
    }
    return [resultArray copy];
}

#pragma -mark GenerateBacbsrackEnrty
-(NSString*) logBacktraceEntry:(const int) entryNum
                   withAddress: (const uintptr_t) address
                    withDlInfo: (const Dl_info* const) dlInfo
{
    char faddrBuff[20];
    //    char saddrBuff[20];
    
    const char* fname = [self lastPathEntry:dlInfo->dli_fname];
    if (fname == NULL) {
        sprintf(faddrBuff, POINTER_FMT, (uintptr_t)dlInfo->dli_fbase);
        fname = faddrBuff;
    }
    
    return [NSString stringWithFormat:@"%s 0x%08lx 0x%08lx", fname, (uintptr_t)dlInfo->dli_fbase, (uintptr_t)address];
}

-(const char*) lastPathEntry:(const char* const) path
{
    if (path == NULL) {
        return NULL;
    }
    
    char *lastFile = strrchr(path, '/');
    return lastFile == NULL ? path : lastFile + 1;
}

#pragma -mark HandleMachineContext
-(bool)fillThreadStateIntoMachineContext:(thread_t) thread  witchMachContext: (_STRUCT_MCONTEXT*)machineContext
{
    mach_msg_type_number_t state_count = THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread, THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
    return (kr == KERN_SUCCESS);
}

-(uintptr_t)mach_framePointer:(mcontext_t)machineContext
{
    return machineContext->__ss.FRAME_POINTER;
}

-(uintptr_t)mach_stackPointer:(mcontext_t) machineContext
{
    return machineContext->__ss.STACK_POINTER;
}

-(uintptr_t) mach_instructionAddress:(mcontext_t) machineContext
{
    return machineContext->__ss.INSTRUCTION_ADDRESS;
}

-(uintptr_t) mach_linkRegister:(mcontext_t const) machineContext
{
#if defined(__i386__) || defined(__x86_64__)
    return 0;
#else
    return machineContext->__ss.__lr;
#endif
}

-(kern_return_t) mach_copyMem:(const void *const) src withDst:(void *const) dst withNumBytes:(const size_t) numBytes
{
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
}

#pragma -mark Symbolicate
-(void) symbolicate:(const uintptr_t* const) backtraceBuffer
     withSymbolsBuf: (Dl_info* const) symbolsBuffer
     withNumEntries:(const int)numEntries
 withSkippedEntries:(const int)skippedEntries
{
    int i = 0;
    
    if (!skippedEntries && i < numEntries) {
        [self fl_dladdr:backtraceBuffer[i] withInfo:&symbolsBuffer[i]];
        i++;
    }
    
    for (; i < numEntries; i++) {
        [self fl_dladdr:CALL_INSTRUCTION_FROM_RETURN_ADDRESS(backtraceBuffer[i]) withInfo:&symbolsBuffer[i]];
    }
}

// 找出addres对应的模块以及最近的函数符号，该方法线程不安全
-(bool) fl_dladdr: (const uintptr_t) address withInfo:( Dl_info* const) info
{
    info->dli_fname = NULL;
    info->dli_fbase = NULL;
    info->dli_sname = NULL;
    info->dli_saddr = NULL;
    
    
    const uint32_t idx = [self imageIndexContainingAddress:address];
    if (idx == UINT_MAX) {
        return false;
    }
    const struct mach_header* header = _dyld_get_image_header(idx);
    const uintptr_t imageVMAddrSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(idx);
    // const uintptr_t addressWithSlide = address - imageVMAddrSlide;
    
    const uintptr_t segmentBase = [self segmentBaseOfImageIndex:idx] + imageVMAddrSlide;
    if (segmentBase == 0) {
        return false;
    }
    
    info->dli_fname = _dyld_get_image_name(idx);
    info->dli_fbase = (void*)header;
    
    return true;
}

-(uintptr_t) firstCmdAfterHeader:(const struct mach_header* const) header
{
    switch (header->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
            return (uintptr_t)(header + 1);
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((struct mach_header_64*)header) + 1);
        default:
            return 0;  // Header is corrupt
    }
}

-(uint32_t) imageIndexContainingAddress:(const uintptr_t) address
{
    const uint32_t imageCount = _dyld_image_count();
    const struct mach_header* header = 0;
    
    for (uint32_t iImg = 0; iImg < imageCount; iImg++) {
        header = _dyld_get_image_header(iImg);
        if (header != NULL) {
            // Look for a segment command with this address within its range.
            uintptr_t addressWSlide = address - (uintptr_t)_dyld_get_image_vmaddr_slide(iImg);
            
            uintptr_t cmdPtr = [self firstCmdAfterHeader:header];
            if (cmdPtr == 0) {
                continue;
            }
            for (uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
                const struct load_command* loadCmd = (struct load_command*)cmdPtr;
                if (loadCmd->cmd == LC_SEGMENT) {
                    const struct segment_command* segCmd = (struct segment_command*)cmdPtr;
                    if (addressWSlide >= segCmd->vmaddr &&
                        addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                else if (loadCmd->cmd == LC_SEGMENT_64) {
                    const struct segment_command_64* segCmd = (struct segment_command_64*)cmdPtr;
                    if (addressWSlide >= segCmd->vmaddr &&
                        addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                cmdPtr += loadCmd->cmdsize;
            }
        }
    }
    return UINT_MAX;
}

-(uintptr_t) segmentBaseOfImageIndex:(const uint32_t) idx
{
    const struct mach_header* header = _dyld_get_image_header(idx);
    
    // Look for a segment command and return the file image address.
    
    uintptr_t cmdPtr = [self firstCmdAfterHeader:header];
    if (cmdPtr == 0) {
        return 0;
    }
    for (uint32_t i = 0;i < header->ncmds; i++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if (loadCmd->cmd == LC_SEGMENT) {
            const struct segment_command* segmentCmd = (struct segment_command*)cmdPtr;
            if (strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return segmentCmd->vmaddr - segmentCmd->fileoff;
            }
        }
        else if (loadCmd->cmd == LC_SEGMENT_64) {
            const struct segment_command_64* segmentCmd = (struct segment_command_64*)cmdPtr;
            if (strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)(segmentCmd->vmaddr - segmentCmd->fileoff);
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return 0;
}

#pragma -mark Convert NSThread to Mach thread
-(thread_t) machThreadFromNSThread:(NSThread*) nsthread
{
    char name[256];
    mach_msg_type_number_t count;
    thread_act_array_t list;
    task_threads(mach_task_self(), &list, &count);
    
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    NSString *originName = [nsthread name];
    [nsthread setName:[NSString stringWithFormat:@"%f", currentTimestamp]];
    
    for (int i = 0; i < count; ++i) {
        pthread_t pt = pthread_from_mach_thread_np(list[i]);
        if (pt) {
            name[0] = '\0';
            pthread_getname_np(pt, name, sizeof name);
            if (!strcmp(name, [nsthread name].UTF8String)) {
                [nsthread setName:originName];
                return list[i];
            }
        }
    }
    
    [nsthread setName:originName];
    return mach_thread_self();
}

-(bool) loadAllThreads
{
    task_t this_task = mach_task_self();
    
    kern_return_t kr = task_threads(this_task, &_threads, &_thread_count);
    return kr == KERN_SUCCESS;
}

-(double)currentCpuUsageForTask
{
    kern_return_t error;
    [self loadAllThreads];
    const task_t this_task = mach_task_self();
    mach_msg_type_number_t count;
    double totalCpuUsage = 0;
    struct task_basic_info ti;
    error = task_info(this_task, TASK_BASIC_INFO, (task_info_t)&ti, &count);
    double threads_user_time = 0;
    double threads_system_time = 0;
    
    for (unsigned i = 0; i < _thread_count; ++i) {
        if (_threads[i] == _current_thread_id) {
            continue;
        }
        kern_return_t error;
        mach_msg_type_number_t count;
        thread_basic_info_t thi;
        thread_basic_info_data_t thi_data;
        thi = &thi_data;
        count = THREAD_BASIC_INFO_COUNT;
        error = thread_info(_threads[i], THREAD_BASIC_INFO, (thread_info_t)thi, &count);
        if (error == KERN_SUCCESS) {
            threads_user_time += thi->user_time.seconds + thi->user_time.microseconds * 1e-6;
            threads_system_time += thi->system_time.seconds + thi->system_time.microseconds * 1e-6;
            if ((thi->flags & TH_FLAGS_IDLE) == 0) {
                totalCpuUsage += thi->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
            }
        }
    }
    return totalCpuUsage;
}

- (double)currentMemoryForTask
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_INFO_MAX;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }
    double resident_size = taskInfo.resident_size / 1024.0 / 1024.0;
    return resident_size;
}

// 获取cpu耗时和堆栈信息前调用
- (void)prepare
{
    // 获取当前thread的thread_id
    _current_thread_id = [self machThreadFromNSThread:[NSThread currentThread]];
}

@end

