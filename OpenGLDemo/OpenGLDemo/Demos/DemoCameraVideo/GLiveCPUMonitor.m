#import "GLiveCPUMonitor.h"
#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>
#import "GLiveThreadLogger.h"


static GLiveCPUMonitor *instance = nil;

@interface GLiveCPUMonitor ()
{
    NSUInteger _lastOverThresholdTime;
    BOOL _isRunning;
    NSMutableArray *_cacheBacktraceLogs;
    NSMutableArray *_cacheUsageLogs;
    double _lastCPUTime; //上一次超过CPU耗时阈值的时刻
    NSRunLoop *_timerRunloop;
    NSTimer *_timer;
}

@end

@implementation GLiveCPUMonitor

+ (GLiveCPUMonitor *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [GLiveCPUMonitor new];
        }
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 默认设置当持续5次，cpu占用率超过95%时打印线程信息
        _lastFrequency = 5;
        _cpuThresholdInPercent = 95;
        _isRunning = NO;
        _lastCPUTime = 0;
        _monitorIntervalInSecond = 2;
    }
    return self;
}

- (void)startMonitor
{
    if (!_isRunning) {
        _lastOverThresholdTime = [[NSDate date] timeIntervalSince1970];
        _isRunning = YES;
        _cacheBacktraceLogs = [NSMutableArray new];
        _cacheUsageLogs = [NSMutableArray new];
        NSThread *timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startMonitorInNewThread:) object:nil];
        [timerThread setName:@"com.tencent.glive.timer_thread"];
        [timerThread start];
    }
}

- (void)startMonitorInNewThread:(id)sender
{
    _timerRunloop = [NSRunLoop currentRunLoop];
    _timer = [NSTimer timerWithTimeInterval:_monitorIntervalInSecond target:self selector:@selector(monitorCPU:) userInfo:nil repeats:YES];
    [_timerRunloop addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timerRunloop run];
}

-(double)currentCpuUsageForTask
{
    
    mach_port_t current_thread_id;
    thread_act_array_t threads;
    mach_msg_type_number_t thread_count;
    kern_return_t error;
    
    const task_t this_task = mach_task_self();
    kern_return_t kr = task_threads(this_task, &threads, &thread_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    mach_msg_type_number_t count;
    double totalCpuUsage = 0;
    struct task_basic_info ti;
    error = task_info(this_task, TASK_BASIC_INFO, (task_info_t)&ti, &count);
    double threads_user_time = 0;
    double threads_system_time = 0;
    
    for (unsigned i = 0; i < thread_count; ++i) {
        if (threads[i] == current_thread_id) {
            continue;
        }
        kern_return_t error;
        mach_msg_type_number_t count;
        thread_basic_info_t thi;
        thread_basic_info_data_t thi_data;
        thi = &thi_data;
        count = THREAD_BASIC_INFO_COUNT;
        error = thread_info(threads[i], THREAD_BASIC_INFO, (thread_info_t)thi, &count);
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

-(double)currentMemoryForTask
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

- (void)monitorCPU:(id)sender
{

    //GLiveLogFinal("GLivePerf monitor, currentCpuUsage=%f, currentMemoryForTask=%f", currentCpuUsage, currentMemoryForTask);
    double currentMemoryForTask = [[GLiveThreadLogger shareInstance] currentMemoryForTask];
    double currentCpuUsage =[[GLiveThreadLogger shareInstance] currentCpuUsageForTask];
    NSLog(@"GLivePerf memory:%f, cupUsage:%f", currentMemoryForTask, currentCpuUsage);
    
    NSUInteger currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if (currentCpuUsage < _cpuThresholdInPercent) {
        // 如果当前CPU占用率低于阈值，刷新上次超过阈值的时间戳
        _lastOverThresholdTime = currentTimestamp;
        [_cacheBacktraceLogs removeAllObjects];
        [_cacheUsageLogs removeAllObjects];
    } else if ((currentTimestamp - _lastOverThresholdTime) >= _lastFrequency * _monitorIntervalInSecond) {
        [_cacheUsageLogs addObject:[[GLiveThreadLogger shareInstance] logOfAllThreadUsage]];
        [_cacheBacktraceLogs addObject:[[GLiveThreadLogger shareInstance] logOfAllThread]];
        // 一次监控只打印一次线程堆栈
        if (_isRunning) {
            [_timer invalidate];
            _isRunning = NO;
            if (_monitorDelegate && [_monitorDelegate respondsToSelector:@selector(didCaptureUsageLog:andBacktraceLog:)]) {
                [_monitorDelegate didCaptureUsageLog:[_cacheUsageLogs copy] andBacktraceLog:[_cacheBacktraceLogs copy]];
            }
        }
    } else {
        [_cacheUsageLogs addObject:[[GLiveThreadLogger shareInstance] logOfAllThreadUsage]];
        [_cacheBacktraceLogs addObject:[[GLiveThreadLogger shareInstance] logOfAllThread]];
    }
}

- (void)stopMonitor
{
    if (_isRunning) {
        [_timer invalidate];
        _isRunning = NO;
    }
}

- (void)setCpuThreshold:(double)cpuThreshold
{
    _cpuThresholdInPercent = cpuThreshold;
    if (_isRunning) {
        // 每次设置监控参数，重置上次超过阈值的时间戳
        _lastOverThresholdTime = [[NSDate date] timeIntervalSince1970];
    }
}

- (void)setLastFrequency:(NSUInteger)lastFrequency
{
    _lastFrequency = lastFrequency;
    if (_isRunning) {
        _lastOverThresholdTime = [[NSDate date] timeIntervalSince1970];
    }
}

- (BOOL)isMonitoring
{
    return _isRunning;
}

@end
