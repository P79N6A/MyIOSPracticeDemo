
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIDevice+Util"
#pragma clang diagnostic pop

//
//  UIDevice+Util.m
//  QQMSFContact
//
//  Created by Will on 14-7-29.
//
//

#import "UIDevice+Util.h"
#import "UIScreenEx.h"
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/sysctl.h>
#import <mach/mach.h>

//@implementation UIDevice (Util)

//+ (NSString *)sysInfoByName:(char *)typeSpecifier
//{
//    size_t size;
//    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
//    
//    char *answer = malloc(size);
//    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
//    
//    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
//    
//    free(answer);
//    return results;
//}

//+ (NSUInteger) getSysInfo: (uint) typeSpecifier
//{
//    size_t size = sizeof(int);
//    int results;
//    int mib[2] = {CTL_HW, typeSpecifier};
//    sysctl(mib, 2, &results, &size, NULL, 0);
//    return (NSUInteger) results;
//}

//@end
//UTF8StringPtr kCZStringWithUTF8StringPtr = 0l;
//NSString *CZ_NSString_stringWithFormat_c(const char *cformat, ...){
//    va_list args;
//    va_start(args, cformat);
//    NSString *ret = [[[NSString alloc] initWithFormat:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),cformat) arguments:args] autorelease];
//    va_end(args);
//    return ret;
//}
//

@implementation UIDevice (HardWare)



//+ (NSString *)platform
//{
//    return [UIDevice sysInfoByName:"hw.machine"];
//}

//+ (NSString *)hwmodel
//{
//    return [UIDevice sysInfoByName:"hw.model"];
//}
/*
+ (UIDevicePlatform)platformType
{
    NSString *platform = [UIDevice platform];
    
    // The ever mysterious iFPGA
    if (CZ_StringEqualToString_c(platform,"iFPGA"))        return UIDeviceIFPGA;
    
    // iPhone
    if (CZ_StringEqualToString_c(platform,"iPhone1,1"))    return UIDevice1GiPhone;
    if (CZ_StringEqualToString_c(platform,"iPhone1,2"))    return UIDevice3GiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone2"))            return UIDevice3GSiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone3"))            return UIDevice4iPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone4"))            return UIDevice4SiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone5"))            return UIDevice5iPhone;
    if (CZ_StringEqualToString_c(platform,"iPhone6,2"))    return UIDevice5SiPhone;
    
    // iPod
    if (CZ_StringHasPrefix_c(platform,"iPod1"))              return UIDevice1GiPod;
    if (CZ_StringHasPrefix_c(platform,"iPod2"))              return UIDevice2GiPod;
    if (CZ_StringHasPrefix_c(platform,"iPod3"))              return UIDevice3GiPod;
    if (CZ_StringHasPrefix_c(platform,"iPod4"))              return UIDevice4GiPod;
    if (CZ_StringHasPrefix_c(platform,"iPod5,1"))            return UIDevice5GiPod;
    
    // iPad
    if (CZ_StringHasPrefix_c(platform,"iPad1"))              return UIDevice1GiPad;
    if (CZ_StringHasPrefix_c(platform,"iPad2"))              return UIDevice2GiPad;
    if (CZ_StringHasPrefix_c(platform,"iPad3"))              return UIDevice3GiPad;
    if (CZ_StringHasPrefix_c(platform,"iPad4"))              return UIDevice4GiPad;
    
    // Apple TV
    if (CZ_StringHasPrefix_c(platform,"AppleTV2"))           return UIDeviceAppleTV2;
    if (CZ_StringHasPrefix_c(platform,"AppleTV3"))           return UIDeviceAppleTV3;
    
    if (CZ_StringHasPrefix_c(platform,"iPhone"))             return UIDeviceUnknowniPhone;
    if (CZ_StringHasPrefix_c(platform,"iPod"))               return UIDeviceUnknowniPod;
    if (CZ_StringHasPrefix_c(platform,"iPad"))               return UIDeviceUnknowniPad;
    if (CZ_StringHasPrefix_c(platform,"AppleTV"))            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = getScreenWidth() < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}*/
/*
+ (NSString *)platformString
{
    switch ([UIDevice platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDevice5SiPhone: return IPHONE_5S_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDevice5GiPod: return IPOD_5G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDevice4GiPad : return IPAD_4G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}
*/
//+ (UIDeviceFamily)deviceFamily
//{
//    NSString *platform = [self platform];
//    if (CZ_StringHasPrefix_c(platform,"iPhone")) return UIDeviceFamilyiPhone;
//    if (CZ_StringHasPrefix_c(platform,"iPod")) return UIDeviceFamilyiPod;
//    if (CZ_StringHasPrefix_c(platform,"iPad")) return UIDeviceFamilyiPad;
//    if (CZ_StringHasPrefix_c(platform,"AppleTV")) return UIDeviceFamilyAppleTV;
//    
//    return UIDeviceFamilyUnknown;
//}

+ (NSString *)deviceIdentifier
{
    NSString *ifv = @"";

    ifv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    return ifv;
}

//+ (BOOL)isIphone5EarlyDevice
//{
//    UIDevicePlatform type = UIDeviceUnknown;
//    if (type == UIDeviceUnknown) {
//        type = (UIDevicePlatform)[[UIDevice currentDevice] platformType];
//    }
//    return (type == UIDevice1GiPhone ||
//            type == UIDevice3GiPhone ||
//            type == UIDevice3GSiPhone||
//            type == UIDevice4iPhone  ||
//            type == UIDevice4SiPhone ||
//            type == UIDevice1GiPod  ||
//            type == UIDevice2GiPod  ||
//            type == UIDevice3GiPod  ||
//            type == UIDevice4GiPod  ||
//            type == UIDevice5GiPod );
//}
//
//+ (BOOL)isIphone4EarlyDevice
//{
//    NSUInteger type = UIDeviceUnknown;
//    if (type == UIDeviceUnknown) {
//        type = [[UIDevice currentDevice] platformType];
//    }
//    return (type == UIDevice1GiPhone ||
//            type == UIDevice3GiPhone ||
//            type == UIDevice3GSiPhone ||
//            type == UIDevice1GiPod ||
//            type == UIDevice2GiPod ||
//            type == UIDevice3GiPod ||
//            type == UIDevice4GiPod );
//}

@end

@implementation UIDevice (System)

//+ (BOOL)isSupportBackgroundRefresh
//{
//    if ([kCZUIApplication respondsToSelector:@selector(backgroundRefreshStatus)])
//    {
//        return kCZUIApplication.backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable;
//    }
//
//    return false;
//}

@end

@implementation UIDevice (ScreenSize)

+ (UIDeviceResolution)currentDeviceResolution
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        CGSize result = getScreenSize();
        result = CGSizeMake(result.width * getScreenScale(), result.height * getScreenScale());
        
        if (result.height == 960)
        {
            return UIDevice_iPhoneHiRes;
            
        }else if (result.height == 1136)
        {
            return UIDevice_iPhoneTallerHiRes;
        }else if (result.height == 1334)
        {
            return UIDevice_iPhone6Res;
        }else if (result.height == 2208)
        {
        
            return UIDevice_iPhone6PlusRes;
        }else{
        
            return UIDevice_iPhoneTallerHiRes;
        }
    } else
        return  UIDevice_iPadHiRes;
}

+ (BOOL)isRetinaDisplay
{
    return (getScreenScale() == 2.0f);
}

@end

@implementation UIDevice (Memory)

+ (unsigned long long)totalMemory
{
    unsigned long long nearest = 256;
    unsigned long long totalMemory = (int)[[NSProcessInfo processInfo] physicalMemory] / 1024 / 1024;
    unsigned long long rem = (int)totalMemory % nearest;
    unsigned long long tot = 0;
    if (rem >= nearest/2) {
        tot = (totalMemory - rem)+256;
    } else {
        tot = (totalMemory - rem);
    }
    
    return tot;
}

//+ (CGFloat)freeMemory
//{
//    double totalMemory = 0.00;
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
//    if(kernReturn != KERN_SUCCESS) {
//        return -1;
//    }
//    totalMemory = ((vm_page_size * vmStats.free_count) / 1024) / 1024;
//    
//    return totalMemory;
//}

+ (unsigned long long)usedMemory
{
    unsigned long long usedMemory = 0.00;
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return -1;
    }
    usedMemory = ((vm_page_size * (vmStats.active_count + vmStats.inactive_count + vmStats.wire_count)) / 1024) / 1024;
    
    return usedMemory;
}

+ (void)report_memory
{
#if FORCE_OPEN_LOG
    static double last_resident_size = 0.0; //之前的内存
    static double greatest_resident_size = 0.0; //最大的内存
    static double last_greatest_resident_size = 0.0;//之前的最大内存
    
    double current_resident_size = [UIDevice usedMemory];
    if (current_resident_size > 0)
    {
        double diff = current_resident_size - last_resident_size;
        if (current_resident_size > greatest_resident_size)
        {
            greatest_resident_size = current_resident_size;
        }
        double greatest_diff = greatest_resident_size - last_greatest_resident_size;
        double last_greatest_diff = current_resident_size - greatest_resident_size;
        QLog_Info(MODULE_IMPB_UIFRAMEWORK, "current memory is %6.2lf MB, different between current memory and last memory is %6.2lf MB, different between current memory and greatest memory is %6.2lf MB, different between current greatest memory and last greatest memory is %6.2lf MB ", current_resident_size, diff, last_greatest_diff, greatest_diff);
    }
    last_resident_size = current_resident_size;
    last_greatest_resident_size = greatest_resident_size;
#endif
}

@end

@implementation UIDevice (Disk)

//+ (NSNumber *)totalDiskSpace
//{
//    NSDictionary *fattributes = [g_var_NSFileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
//    return CZ_DicGetValueForKey( fattributes , NSFileSystemSize );
//}
//
//+ (NSNumber *)freeDiskSpace
//{
//    NSDictionary *fattributes = [g_var_NSFileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
//    return CZ_DicGetValueForKey( fattributes , NSFileSystemFreeSize );
//}

@end

@implementation UIDevice (Network)

+ (NSString *)macaddress
{
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error\n");
//        return NULL;
//    }
//
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1\n");
//        return NULL;
//    }
//
//    if ((buf = malloc(len)) == NULL) {
//        printf("Error: Memory allocation error\n");
//        return NULL;
//    }
//
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2\n");
//        free(buf); // Thanks, Remy "Psy" Demerest
//        return NULL;
//    }
//
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//
//    NSString *outstring = CZ_NSString_stringWithFormat_c("%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
//
//    free(buf);
    NSString *outstring = nil;
    return outstring;
}

//+ (NSString *)currentIPAddress
//{
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    NSString *wifiAddress = nil;
//    NSString *cellAddress = nil;
//
//    // retrieve the current interfaces - returns 0 on success
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
//            if(sa_type == AF_INET || sa_type == AF_INET6) {
//                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
//                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
//                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
//
//                if(CZ_StringEqualToString_c(name,"en0"))
//                    // Interface is the wifi connection on the iPhone
//                    wifiAddress = addr;
//                else
//                    if(CZ_StringEqualToString_c(name,"pdp_ip0"))
//                        // Interface is the cell connection on the iPhone
//                        cellAddress = addr;
//
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
//    return addr ? addr : @"0.0.0.0";
//}

@end

@implementation UIDevice (JailBreak)

+ (BOOL)isJailBroken
{
//    static BOOL qZoneJailBroken = NO;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *cydiaPath = @"/Applications/Cydia.app";
//        NSString *aptPath = @"/private/var/lib/apt/";
//        if (CZ_IsFileExistFunc(cydiaPath)) {
//            qZoneJailBroken = YES;
//        }
//        if (CZ_IsFileExistFunc(aptPath)) {
//            qZoneJailBroken = YES;
//        }
//    });
//
//    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
//    BOOL qqJailBroken = [kCZUIApplication canOpenURL:url];
//
//    return qZoneJailBroken || qqJailBroken;
    return NO;
}

+ (BOOL)isFullJaleBrokenPatch
{
//    double s_SystemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    //7.0 只针对7.x的用户做这个检查，因为到目前为止只有7.x系统才有自动重连下载的逻辑
//    if (s_SystemVersion < 8.0)
//    {
//        NSString * ppsyncrtfilePath = @"bin/ppsync.dylib";
//        if (CZ_IsFileExistFunc(ppsyncrtfilePath))
//        {
////            QLog_Info(MODULE_IMPB_UIFRAMEWORK, "越狱安装了appsync7.x补丁");
//            return YES;
//        }
//        else
//        {
////            QLog_Info(MODULE_IMPB_UIFRAMEWORK, "越狱没有安装了appsync7.x补丁");
//            return NO;
//        }
//    }
    
    return YES;
}

@end

@implementation UIDevice (Battery)

+ (CGFloat)batteryLevel
{
    CGFloat batteryLevel = 0.0f;
    CGFloat batteryCharge = [UIDevice currentDevice].batteryLevel;
    if (batteryCharge > 0.0f)
    {
        batteryLevel = batteryCharge * 100;
    }
    else
    {
        return -1;
    }
    
    return batteryLevel;
}

@end

@implementation UIDevice (Prosessor)

//+ (NSUInteger) cpuFrequency
//{
//    return [UIDevice getSysInfo:HW_CPU_FREQ];
//}

//+ (NSUInteger) busFrequency
//{
//    return [UIDevice getSysInfo:HW_BUS_FREQ];
//}

//+ (NSUInteger)cpuCount
//{
//    return [UIDevice getSysInfo:HW_NCPU];
//}

//+ (NSString *)cpuType
//{
//    size_t size = 0;
//    cpu_type_t type = 0;
//    cpu_subtype_t subtype = 0;
//
//    size = sizeof(type);
//    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
//    
//    size = sizeof(subtype);
//    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
//
//    if (type == CPU_TYPE_X86)
//    {
//        return @"x86";
//    }
//    else if (type == CPU_TYPE_X86_64)
//    {
//        return @"x86_64";
//    }
//    else if (type == CPU_TYPE_ARM)
//    {
//        if (subtype == CPU_SUBTYPE_ARM_V6)
//        {
//            return @"armv6";
//        }
//        else if (subtype == CPU_SUBTYPE_ARM_V7)
//        {
//            return @"armv7";
//        }
//        else if (subtype == CPU_SUBTYPE_ARM_V7S)
//        {
//            return @"armv7s";
//        }
//#if !(TARGET_IPHONE_SIMULATOR) & __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//        else if (subtype == CPU_SUBTYPE_ARM_V8)
//        {
//            return @"armv8";
//        }
//#endif
//        else
//        {
//            return CZ_NSString_stringWithFormat_c("arm_%d_%d", type & 0xff, subtype & 0xff);
//        }
//    }
//#if !(TARGET_IPHONE_SIMULATOR) & __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//    else if (type == CPU_TYPE_ARM64)
//    {
//        if (subtype == CPU_SUBTYPE_ARM64_ALL)
//        {
//            return @"arm64";
//        }
//        else if (subtype == CPU_SUBTYPE_ARM64_V8)
//        {
//            return @"arm64v8";
//        }
//        else
//        {
//            return CZ_NSString_stringWithFormat_c("arm64_%d_%d", type & 0xff, subtype & 0xff);
//
//        }
//    }
//#endif
//    else
//    {
//        return CZ_NSString_stringWithFormat_c("cpu_%d.%d", type & 0xff, subtype & 0xff);
//    }
//}

@end

@implementation UIDevice (Magnifier)

+ (NSString*) convertModel:(NSString*)platform
{
    //iPhone
    if (CZ_StringEqualToString_c(platform,"iPhone1,1")) return @"iPhone 1";
    if (CZ_StringEqualToString_c(platform,"iPhone1,2")) return @"iPhone 3";
    if (CZ_StringEqualToString_c(platform,"iPhone2,1")) return @"iPhone 3GS";
    if (CZ_StringEqualToString_c(platform,"iPhone3,1")) return @"iPhone 4";
    if (CZ_StringEqualToString_c(platform,"iPhone3,2")) return @"iPhone 4";
    if (CZ_StringEqualToString_c(platform,"iPhone3,3")) return @"iPhone 4";
    if (CZ_StringEqualToString_c(platform,"iPhone4,1")) return @"iPhone 4s";
    if (CZ_StringEqualToString_c(platform,"iPhone5,1")) return @"iPhone 5";
    if (CZ_StringEqualToString_c(platform,"iPhone5,2")) return @"iPhone 5";
    if (CZ_StringEqualToString_c(platform,"iPhone5,3")) return @"iPhone 5C";
    if (CZ_StringEqualToString_c(platform,"iPhone5,4")) return @"iPhone 5C";
    if (CZ_StringEqualToString_c(platform,"iPhone6,1")) return @"iPhone 5S";
    if (CZ_StringEqualToString_c(platform,"iPhone6,2")) return @"iPhone 5S";
    if (CZ_StringEqualToString_c(platform,"iPhone7,1")) return @"iPhone 6 Plus";
    if (CZ_StringEqualToString_c(platform,"iPhone7,2")) return @"iPhone 6 ";
    if (CZ_StringEqualToString_c(platform,"iPhone8,1")) return @"iPhone 6S";
    if (CZ_StringEqualToString_c(platform,"iPhone8,2")) return @"iPhone 6S Plus";
    if (CZ_StringEqualToString_c(platform,"iPhone8,4")) return @"iPhone SE";
    //iPot Touch
    if (CZ_StringEqualToString_c(platform,"iPod1,1")) return @"iPod Touch";
    if (CZ_StringEqualToString_c(platform,"iPod2,1")) return @"iPod Touch 2";
    if (CZ_StringEqualToString_c(platform,"iPod3,1")) return @"iPod Touch 3";
    if (CZ_StringEqualToString_c(platform,"iPod4,1")) return @"iPod Touch 4";
    if (CZ_StringEqualToString_c(platform,"iPod5,1")) return @"iPod Touch 5";
    //iPad
    if (CZ_StringEqualToString_c(platform,"iPad1,1")) return @"iPad";
    if (CZ_StringEqualToString_c(platform,"iPad2,1")) return @"iPad 2";
    if (CZ_StringEqualToString_c(platform,"iPad2,2")) return @"iPad 2";
    if (CZ_StringEqualToString_c(platform,"iPad2,3")) return @"iPad 2";
    if (CZ_StringEqualToString_c(platform,"iPad2,4")) return @"iPad 2";
    if (CZ_StringEqualToString_c(platform,"iPad2,5")) return @"iPad Mini 1";
    if (CZ_StringEqualToString_c(platform,"iPad2,6")) return @"iPad Mini 1";
    if (CZ_StringEqualToString_c(platform,"iPad2,7")) return @"iPad Mini 1";
    if (CZ_StringEqualToString_c(platform,"iPad3,1")) return @"iPad 3";
    if (CZ_StringEqualToString_c(platform,"iPad3,2")) return @"iPad 3";
    if (CZ_StringEqualToString_c(platform,"iPad3,3")) return @"iPad 3";
    if (CZ_StringEqualToString_c(platform,"iPad3,4")) return @"iPad 4";
    if (CZ_StringEqualToString_c(platform,"iPad3,5")) return @"iPad 4";
    if (CZ_StringEqualToString_c(platform,"iPad3,6")) return @"iPad 4";
    if (CZ_StringEqualToString_c(platform,"iPad4,1")) return @"iPad air";
    if (CZ_StringEqualToString_c(platform,"iPad4,2")) return @"iPad air";
    if (CZ_StringEqualToString_c(platform,"iPad4,3")) return @"iPad air";
    if (CZ_StringEqualToString_c(platform,"iPad4,4")) return @"iPad mini 2";
    if (CZ_StringEqualToString_c(platform,"iPad4,5")) return @"iPad mini 2";
    if (CZ_StringEqualToString_c(platform,"iPad4,6")) return @"iPad mini 2";
    if (CZ_StringEqualToString_c(platform,"iPad4,7")) return @"iPad mini 3";
    if (CZ_StringEqualToString_c(platform,"iPad4,8")) return @"iPad mini 3";
    if (CZ_StringEqualToString_c(platform,"iPad4,9")) return @"iPad mini 3";
    if (CZ_StringEqualToString_c(platform,"iPad5,3")) return @"iPad air 2";
    if (CZ_StringEqualToString_c(platform,"iPad5,4")) return @"iPad air 2";
    if (CZ_StringEqualToString_c(platform,"iPhone Simulator") || CZ_StringEqualToString_c(platform,"x86_64")) return @"iPhone Simulator";
    return platform;
}

+ (NSString*)getFirma
{
    return [self convertModel:[[UIDevice currentDevice] platform]];
}



//获取操作系统
+ (NSString*)getOperationSys
{
    NSString* version = [[UIDevice currentDevice]systemName];
    version = CZ_stringByAppendingString_c(version," ");//空格
    version = [version stringByAppendingString:[[UIDevice currentDevice]systemVersion]];
    return version;
}

//平台
+ (NSString*)getPlatform
{
    //    return [[UIDevice currentDevice]systemName];
    return @"ios";
}

+(BOOL)isIphone6or6Plus
{
    NSString *platform=[UIDevice getMachineType];
    BOOL iphone6or6Plus=CZ_StringEqualToString_c(platform,"iPhone7,1") || CZ_StringEqualToString_c(platform,"iPhone7,2");
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
        if (getScreenWidth()>320) {
            iphone6or6Plus = YES;
        }
    }
    return iphone6or6Plus;
}
+(NSString *)getMachineType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platForm = nil;
    if (machine == NULL) {
        platForm=@"i386";
    }else{
        platForm=CZ_UTF8String(machine);
    }
    free(machine);
    return platForm;
}

//设备类型
//0：未知类型
//1：android
//2：ios
//3：android pad
//4:ipad
+ (int)getDeviceType
{
    return 2;
}

//获取分辨率
+ (CGSize)getResolution
{
    CGFloat scale_screen = getScreenScale();
    CGSize size = getScreenSize();
    size.width = size.width*scale_screen;
    size.height = size.height*scale_screen;
    return size;
}

//获取最大堆内存
+ (int)getMaxMemoryHeap
{
    return 0;
}

@end
