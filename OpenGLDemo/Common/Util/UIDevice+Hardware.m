/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+Hardware.h"
#import <sys/sysctl.h>

@implementation UIDevice (Hardware)
/*
 Platforms
 
 iFPGA ->        ??

 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD

 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)

 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??

 i386, x86_64 -> iPhone Simulator
*/


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *) platform
{
    //    @synchronized(self)
    //    {
    //        static NSString* pl = nil;
    //        if (!pl) {
    //            pl = [[self getSysInfoByName:"hw.machine"] retain];
    //        }
    //        return pl;
    //    }
    
    static NSString *model;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char *)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        if (machine == NULL) {
            model = @"i386";
        } else {
            model = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        }
        free(machine);
    });
    
    return (model?:@"iPhoneUnknown");
}

// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    unsigned long long results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
*/

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (uint64_t) freeDiskSpace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

- (float) osVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark platform type and name utils
BOOL compareString(NSString * aString , NSString *bString)
{
    return [aString isEqualToString:bString];
}

BOOL hasPrefixString(NSString * aString , NSString *bString)
{
    return [aString hasPrefix:bString];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if (compareString(platform,@"iPhone1,1"))    return UIDevice1GiPhone;
    if (compareString(platform,@"iPhone1,2"))    return UIDevice3GiPhone;
    if (hasPrefixString(platform,@"iPhone2"))            return UIDevice3GSiPhone;
    if (hasPrefixString(platform,@"iPhone3"))            return UIDevice4iPhone;
    if (hasPrefixString(platform,@"iPhone4"))            return UIDevice4SiPhone;
    if (hasPrefixString(platform,@"iPhone5"))            return UIDevice5iPhone;
    if (compareString(platform,@"iPhone6,2")
        || compareString(platform,@"iPhone6,1")) return UIDevice5SiPhone;  //6,1电信 6,2移动联通
    if (compareString(platform,@"iPhone7,1"))    return UIDevice6Plus;
    if (compareString(platform,@"iPhone7,2"))    return UIDevice6;
    if (compareString(platform,@"iPhone8,1"))    return UIDevice6SiPhone;
    if (compareString(platform,@"iPhone8,2"))    return UIDevice6SPlus;
    if (compareString(platform,@"iPhone8,4"))    return UIDeviceSE;
    if (compareString(platform, @"iPhone9,1") || compareString(platform, @"iPhone9,3"))   return UIDevice7iPhone;
    if (compareString(platform, @"iPhone9,2") || compareString(platform, @"iPhone9,4"))   return UIDevice7Plus;
    if (compareString(platform, @"iPhone10,1") || compareString(platform, @"iPhone10,4"))   return UIDevice8iPhone;
    if (compareString(platform, @"iPhone10,2") || compareString(platform, @"iPhone10,5"))   return UIDevice8Plus;
    if (compareString(platform, @"iPhone10,3") || compareString(platform, @"iPhone10,6"))   return UIDeviceXiPhone;
    
    //新增iPhone
    if (compareString(platform,@"iPhone11,1"))            return UIDeviceXiPhone;//return UIDevice9iPhone;
    if (compareString(platform,@"iPhone11,2"))            return UIDeviceXiPhone;//return UIDeviceXSiPhone;
    if (compareString(platform,@"iPhone11,3"))            return UIDeviceXiPhone;//return UIDeviceXPiPhone;
    
    if (compareString(platform,@"iPhone11"))            return UIDeviceXiPhone;//return UIDeviceXPiPhone;
    
    // iPod
    if (hasPrefixString(platform,@"iPod1"))              return UIDevice1GiPod;
    if (hasPrefixString(platform,@"iPod2"))              return UIDevice2GiPod;
    if (hasPrefixString(platform,@"iPod3"))              return UIDevice3GiPod;
    if (hasPrefixString(platform,@"iPod4"))              return UIDevice4GiPod;
    if (hasPrefixString(platform,@"iPod5,1"))            return UIDevice5GiPod;
    
    // iPad
    if (hasPrefixString(platform,@"iPad1"))              return UIDevice1GiPad;
    if (hasPrefixString(platform,@"iPad2"))              return UIDevice2GiPad;
    if (hasPrefixString(platform,@"iPad3"))              return UIDevice3GiPad;
    if (hasPrefixString(platform,@"iPad4"))              return UIDevice4GiPad;
    
    // Apple TV
    if (hasPrefixString(platform,@"AppleTV2"))           return UIDeviceAppleTV2;
    if (hasPrefixString(platform,@"AppleTV3"))           return UIDeviceAppleTV3;
    
    if (hasPrefixString(platform,@"iPhone"))             return UIDeviceUnknowniPhone;
    if (hasPrefixString(platform,@"iPod"))               return UIDeviceUnknowniPod;
    if (hasPrefixString(platform,@"iPad"))               return UIDeviceUnknowniPad;
    if (hasPrefixString(platform,@"AppleTV"))            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        //BOOL smallerScreen = getScreenWidth() < 768;
        return UIDeviceSimulatoriPhone; //: UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDevice5SiPhone: return IPHONE_5S_NAMESTRING;
        case UIDevice6:         return IPHONE_6_NAMESTRING;
        case UIDevice6Plus:     return IPHONE_6PLUS_NAMESTRING;
        case UIDevice6SiPhone:  return IPHONE_6S_NAMESTRING;
        case UIDevice6SPlus:    return IPHONE_6SPlus_NAMESTRING;
        case UIDevice7iPhone:   return IPHONE_7_NAMESTRING;
        case UIDevice7Plus:     return IPHONE_7Plus_NAMESTRING;
        case UIDevice8iPhone:   return IPHONE_8_NAMESTRING;
        case UIDevice8Plus:     return IPHONE_8Plus_NAMESTRING;
        case UIDeviceXiPhone:   return IPHONE_X_NAMESTRING;
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

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    return outstring;
}
+ (BOOL)isArm64
{
    return (sizeof(void*) == 8);
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
Class  btclass = NSClassFromString(@"GKBluetoothSupport");
if ([btclass respondsToSelector:@selector(bluetoothStatus)])
{
    printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
    bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
    printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
}
*/
@end
