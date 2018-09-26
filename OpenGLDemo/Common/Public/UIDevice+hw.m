
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIDevice+hw"
#pragma clang diagnostic pop

//
//  UIDevice+UIDeviceEX.m
//  QQMSFContact
//
//  Created by zheng bingchao on 13-8-17.
//
//

#if !__has_feature(objc_arc)
#error  does not support Objective-C Automatic Reference Counting (ARC)
#endif

#import "UIDevice+hw.h"
//#import "CodeZipper.h"
#import "UIDevice+Util.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "DCPSetting.h"
//#import "BeaconDeviceUtil.h"

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
//- (NSString *) getSysInfoByName:(char *)typeSpecifier
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
//    
//    if (nil == results || 0 == results.length) {
//        results = @"iPhoneUnknown";
//    }
//    return results;
//}

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
        model = [[BeaconDeviceUtil model] copy];
        QLog_InfoP(MODULE_IMPB_CHAT, "%s model = %s", __FUNCTION__, CZ_getDescription(model));
    });
    
    return (model?:@"iPhoneUnknown");
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

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */
- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [g_var_NSFileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return CZ_DicGetValueForKey( fattributes , NSFileSystemFreeSize );
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if (CZ_StringEqualToString_c(platform,"iFPGA"))        return UIDeviceIFPGA;
    
    // iPhone
    if (CZ_StringEqualToString_c(platform,"iPhone1,1"))    return UIDevice1GiPhone;
    if (CZ_StringEqualToString_c(platform,"iPhone1,2"))    return UIDevice3GiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone2"))            return UIDevice3GSiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone3"))            return UIDevice4iPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone4"))            return UIDevice4SiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPhone5"))            return UIDevice5iPhone;
    if (CZ_StringEqualToString_c(platform,"iPhone6,2")
        || CZ_StringEqualToString_c(platform,"iPhone6,1")) return UIDevice5SiPhone;  //6,1电信 6,2移动联通
    if (CZ_StringEqualToString_c(platform,"iPhone7,1"))    return UIDevice6Plus;
    if (CZ_StringEqualToString_c(platform,"iPhone7,2"))    return UIDevice6;
    if (CZ_StringEqualToString_c(platform,"iPhone8,1"))    return UIDevice6SiPhone;
    if (CZ_StringEqualToString_c(platform,"iPhone8,2"))    return UIDevice6SPlus;
    if (CZ_StringEqualToString_c(platform,"iPhone8,4"))    return UIDeviceSE;
    if (CZ_StringEqualToString_c(platform, "iPhone9,1") || CZ_StringEqualToString_c(platform, "iPhone9,3"))   return UIDevice7iPhone;
    if (CZ_StringEqualToString_c(platform, "iPhone9,2") || CZ_StringEqualToString_c(platform, "iPhone9,4"))   return UIDevice7Plus;
    if (CZ_StringEqualToString_c(platform, "iPhone10,1") || CZ_StringEqualToString_c(platform, "iPhone10,4"))   return UIDevice8iPhone;
    if (CZ_StringEqualToString_c(platform, "iPhone10,2") || CZ_StringEqualToString_c(platform, "iPhone10,5"))   return UIDevice8Plus;
    if (CZ_StringEqualToString_c(platform, "iPhone10,3") || CZ_StringEqualToString_c(platform, "iPhone10,6"))   return UIDeviceXiPhone;
    
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
        if ((375 == SCREEN_WIDTH) && (812 == SCREEN_HEIGHT)) {
            return UIDeviceXiPhone;
        }
        BOOL smallerScreen = getScreenWidth() < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
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
- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if (CZ_StringHasPrefix_c(platform,"iPhone")) return UIDeviceFamilyiPhone;
    if (CZ_StringHasPrefix_c(platform,"iPod")) return UIDeviceFamilyiPod;
    if (CZ_StringHasPrefix_c(platform,"iPad")) return UIDeviceFamilyiPad;
    if (CZ_StringHasPrefix_c(platform,"AppleTV")) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

// 设备支持生物学Id
- (QQBiologyIDType)supportBiologyID {
    if ([self isSupportFaceID]) {
        return QQBiologyIDTypeFaceID;
    } else if ([self isSupportTouchID]) {
        return QQBiologyIDTypeTouchID;
    }
    return QQBiologyIDTypeNone;
}

- (BOOL)isSupportFaceID {
    BOOL isDevSupport = NO;
    NSUInteger platformType = [self platformType];
    if (platformType == UIDeviceXiPhone) {
        isDevSupport = YES;
    }
    
    NSNumber *value = [[DCPSetting instance] getDpcInfo:@"isDevSupportFaceID"];
    if([value respondsToSelector:@selector(boolValue)]) {
        isDevSupport = value.boolValue;
        QLog_Info(MODULE_IMPB_CHAT,"isSupportFaceId = %d", isDevSupport);
    }
    
    return isDevSupport;
}

//判断手机及系统是否支持touchID,用来设置界面是否显示入口
-(BOOL)isSupportTouchID
{
    BOOL isDevSupport = NO;
    NSUInteger platformType = [self platformType];
    if (
        (platformType == UIDevice5SiPhone)
        || (platformType == UIDevice6Plus)
        || (platformType == UIDevice6)
        || (platformType == UIDevice6SiPhone)
        || (platformType == UIDevice6SPlus)
        || (platformType == UIDeviceSE)
        || (platformType == UIDevice7iPhone)
        || (platformType == UIDevice7Plus)
        || (platformType == UIDevice8iPhone)
        || (platformType == UIDevice8Plus)
        ) {
        isDevSupport = YES;
    }
    
    NSNumber *value = [[DCPSetting instance] getDpcInfo:@"isDevSupportTouchID"];
    if(value!= nil) {
        isDevSupport = value.boolValue;
        QLog_Info(MODULE_IMPB_CHAT,"isSupportTouchId = %d",isDevSupport);
    }
    
    if(isDevSupport && SYSTEM_VERSION >= 8.0){
        return YES;
    }
    return NO;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    return [UIDevice macaddress];
}

// Illicit Bluetooth check -- cannot be used in App Store
/*
 Class  btclass = NSClassFromString(@"GKBluetoothSupport");
 if ([btclass respondsToSelector:@selector(bluetoothStatus)])
 {
 printf("BTStatus %zd\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
 bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
 printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
 }
 */
@end
