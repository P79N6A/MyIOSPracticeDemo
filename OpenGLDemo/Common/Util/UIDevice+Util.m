
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
//#import "CodeZipper.h"
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


@end

