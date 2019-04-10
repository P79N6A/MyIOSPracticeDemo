//
//  UIDevice+Util.h
//  QQMSFContact
//
//  Created by Will on 14-7-29.
//
//

#import <UIKit/UIKit.h>
//#import "UIDevice+hw.h"

//@interface UIDevice (Util)
//
//@end

#define IPHONE_STANDARD_RESOLUTION      @"320x960"
#define IPHONE_HIGH_RESOLUTION          @"640x960"
#define IPHONE_SUPER_HIGH_RESOLUTION    @"640x1136"
#define IPHONE_SIX_RESOLUTION           @"750x1334"
#define IPHONE_SIX_PLUS_RESOLUTION      @"1242x2208"

typedef NS_ENUM(NSInteger, UIDeviceResolution)
{
    UIDevice_iPhoneStandardRes      = 1,    // iPhone 1,3,3GS Standard Resolution   (320*960px)
    UIDevice_iPhoneHiRes            = 2,    // iPhone 4,4S High Resolution          (640*960px)
    UIDevice_iPhoneTallerHiRes      = 3,    // iPhone 5,5S High Resolution             (640*1136px)
    UIDevice_iPadStandardRes        = 4,    // iPad 1,2 Standard Resolution         (1024*768px)
    UIDevice_iPadHiRes              = 5,    // iPad 3 High Resolution               (2048*1536px)
    UIDevice_iPhone6Res             = 6,    // iPhone 6  Resolution                 (750*1334)
    UIDevice_iPhone6PlusRes         = 7,    // iPhone 6Plus Resolution              (1242*2208)
};

@interface UIDevice (HardWare)

//+ (NSString *)platform;

//+ (NSString *)hwmodel;

//+ (UIDevicePlatform)platformType;

//+ (NSString *)platformString;

//+ (UIDeviceFamily)deviceFamily;

+ (NSString *)deviceIdentifier;
//+ (BOOL)isIphone5EarlyDevice;
//+ (BOOL)isIphone4EarlyDevice;

@end

@interface UIDevice (System)

+ (BOOL)isSupportBackgroundRefresh;

@end

@interface UIDevice (ScreenSize)

+ (UIDeviceResolution) currentDeviceResolution;

+ (BOOL)isRetinaDisplay;

@end

@interface UIDevice (Memory)

+ (unsigned long long)totalMemory;

/**
 *  FreeMemory
 *
 *  @return freeMemory; return -1 if failed
 */
//+ (CGFloat)freeMemory;

/**
 *  UsedMemory
 *
 *  @return usedMemory; return -1 if failed
 */
+ (unsigned long long)usedMemory;

+ (void)report_memory;

@end

@interface UIDevice (Disk)

+ (NSNumber *)totalDiskSpace;

+ (NSNumber *)freeDiskSpace;

@end

@interface UIDevice (Network)

+ (NSString *)macaddress;

+ (NSString *)currentIPAddress;

@end

@interface UIDevice (JailBreak)

+ (BOOL)isJailBroken;
+ (BOOL)isFullJaleBrokenPatch;

@end

@interface UIDevice (Battery)

+ (CGFloat)batteryLevel;

@end

@interface UIDevice (Prosessor)

//+ (NSUInteger)cpuFrequency;

//+ (NSUInteger)busFrequency;

//+ (NSUInteger)cpuCount;

//+ (NSString *)cpuType;

@end

@interface UIDevice(Magnifier)

+ (NSString*)getFirma;
//获取操作系统
+ (NSString*)getOperationSys;
//平台
+ (NSString*)getPlatform;

//判断是否是iphone6or6P
+(BOOL)isIphone6or6Plus;
+(NSString *)getMachineType;

//设备类型
//0：未知类型
//1：android
//2：ios
//3：android pad
//4:ipad
+ (int)getDeviceType;

//获取分辨率
+ (CGSize)getResolution;

//获取最大堆内存
+ (int)getMaxMemoryHeap;

@end
