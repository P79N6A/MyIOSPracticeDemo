//
//  PLUtilApp.m
//  HuaYang
//
//  Created by xenayang on 15/11/20.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#import "PLUtilApp.h"
#import "PLAppDelegate.h"
#import "PLUtilUIScreen.h"
#import "PLLoginMgr.h"
#include <sys/sysctl.h>
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "PLAppConfigMgr.h"
#import "PLAlertView.h"
#import "PLLoginMgr.h"
#import "PLAppConfigMgr.h"
#import "Network/Util/UtilNetwork.h"
#import "QQOfflineWebApp.h"
#import "PLATSUtil.h"
#import "PLAppDelegate.h"
#import <Util/UtilMisc.h>
#import "PLRootViewController.h"
#import "PLRootTabBarLogic.h"
#import "LCCommonConfigMgr.h"
#import "PLLoginMgr.h"

#define UTILAPP_LOGFILTER @"PLUtilApp"

@implementation PLUtilApp
+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url
{
    NSString *urlPath;
    NSString *urlQuery;
    NSString *urlStirng;
    NSString *urlParameString;
    NSString *randomString;
    
    UInt64 currentUTCTime = [[PLAppConfigMgr shareInstance] serverUTCTime];
    
    urlPath = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([url.absoluteString componentsSeparatedByString:@"?"].count > 1) {
        urlQuery = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1];
    }
    if ([url.absoluteString rangeOfString:@"#"].length>0){
        urlStirng = [[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:0];
        urlParameString =[[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:1];
        randomString = [urlPath stringByAppendingFormat:@"?%@&_t=%llu#%@",urlStirng,currentUTCTime,urlParameString];
    }else{
        if (urlQuery) {
            randomString =  [urlPath stringByAppendingFormat:@"?%@&_t=%llu",urlQuery,currentUTCTime];
        }else{
            randomString =  [urlPath stringByAppendingFormat:@"?_t=%llu",currentUTCTime];
        }
    }
    
    return randomString;
}

+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withTimeStamp:(UINT64)timeStamp
{
    NSString *urlPath;
    NSString *urlQuery;
    NSString *urlStirng;
    NSString *urlParameString;
    NSString *randomString;
    
    urlPath = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([url.absoluteString componentsSeparatedByString:@"?"].count > 1) {
        urlQuery = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1];
    }
    if ([url.absoluteString rangeOfString:@"#"].length>0){
        urlStirng = [[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:0];
        urlParameString =[[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:1];
        randomString = [urlPath stringByAppendingFormat:@"?%@&_t=%llu#%@",urlStirng,timeStamp,urlParameString];
    }else{
        if (urlQuery) {
            randomString =  [urlPath stringByAppendingFormat:@"?%@&_t=%llu",urlQuery,timeStamp];
        }else{
            randomString =  [urlPath stringByAppendingFormat:@"?_t=%llu",timeStamp];
        }
    }
    
    return randomString;
    
    // 酌情覆盖已有_t参数   这段函数写了没用上，弃之又可惜，堆着吧，期待有缘人
    /*NSString *tTag = @"_t=";
    NSString *fromSkipTString = [url.absoluteString substringFromIndex:tRange.location + tTag.length];
    NSArray *arrCompFromSkipTString = [fromSkipTString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#&"]];
    NSString *tValueString = arrCompFromSkipTString[0];
    UINT64 tStamp = [tValueString unsignedLongLongValue];
    if (toOverwriteTimeStamp <= tStamp) {    // 如果已有的t比新写的t还大，放弃覆盖
        return url.absoluteString;
    }
    else {
        return [url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(tRange.location + tTag.length, tValueString.length) withString:[NSString stringWithFormat:@"%llu", toOverwriteTimeStamp]];
    }*/
}

+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withBid:(int)bid
{
    NSString *urlPath;
    NSString *urlQuery;
    NSString *urlStirng;
    NSString *urlParameString;
    NSString *randomString;
    
    urlPath = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([url.absoluteString componentsSeparatedByString:@"?"].count > 1) {
        urlQuery = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1];
    }
    if ([url.absoluteString rangeOfString:@"#"].length>0){
        urlStirng = [[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:0];
        urlParameString =[[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:1];
        randomString = [urlPath stringByAppendingFormat:@"?%@&_bid=%d#%@",urlStirng,bid,urlParameString];
    }else{
        if (urlQuery) {
            randomString =  [urlPath stringByAppendingFormat:@"?%@&_bid=%d",urlQuery,bid];
        }else{
            randomString =  [urlPath stringByAppendingFormat:@"?_bid=%d",bid];
        }
    }
    
    return randomString;
}

+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withParam:(NSString *)paramName value:(UINT64)value
{
    NSString *urlPath;
    NSString *urlQuery;
    NSString *urlStirng;
    NSString *urlParameString;
    NSString *randomString;
    
    urlPath = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([url.absoluteString componentsSeparatedByString:@"?"].count > 1) {
        urlQuery = [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1];
    }
    if ([url.absoluteString rangeOfString:@"#"].length>0){
        urlStirng = [[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:0];
        urlParameString =[[urlQuery componentsSeparatedByString:@"#"] objectAtIndex:1];
        randomString = [urlPath stringByAppendingFormat:@"?%@&%@=%llu#%@",urlStirng,paramName,value,urlParameString];
    }else{
        if (urlQuery) {
            randomString =  [urlPath stringByAppendingFormat:@"?%@&%@=%llu",urlQuery,paramName,value];
        }else{
            randomString =  [urlPath stringByAppendingFormat:@"?%@=%llu",paramName,value];
        }
    }
    
    return randomString;
}

+ (NSString*)getBundleVersionsStringShort
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString*)getBundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString*)getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSInteger)getVersionCode
{
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"VersionCode"] integerValue];
}


+ (PLTabBarController*)appTabBarController
{
    PLRootViewController *rootVC = [self getRootViewVC];
    return rootVC.rootTabBar;
}

+ (UINavigationController*)currentNavigationController
{
    PLRootViewController *rootVC = [self getRootViewVC];
    PLRootTabBarLogic *tabBarLogic = rootVC.tabBarLogic;
    UINavigationController *navigationController = [tabBarLogic currentNavigationController];
    
    if (!navigationController) {
        PLAppDelegate *appDelegate = (PLAppDelegate *)[UIApplication sharedApplication].delegate;
        navigationController = (UINavigationController *)appDelegate.mainWindow.rootViewController;
    }
    
    return navigationController;
}

+ (UIViewController *)currentViewController
{
    UINavigationController* navigationController = [PLUtilApp currentNavigationController];
    if (navigationController.presentedViewController) {
        return navigationController.presentedViewController;
    }
    NSArray* viewControllers = navigationController.viewControllers;
    UIViewController * vc = [viewControllers objectAtIndex:viewControllers.count - 1];
    return vc;
}

+ (PLViewController*)findViewController:(NSString*)className hash:(NSUInteger)hash maxLevel:(NSUInteger)level
{
    UINavigationController* navigationController = [PLUtilApp currentNavigationController];
    if (navigationController == nil) {
        return nil;
    }
    NSUInteger count = navigationController.viewControllers.count;
    for (NSInteger index = count - 1; index >= 0 && level > 0; index--, level--) {
        PLViewController* viewController = [[navigationController viewControllers] objectAtIndex:index];
        if ([viewController isKindOfClass:NSClassFromString(className)] && viewController.hash == hash) {
            return viewController;
        }
    }
    return nil;
}

+ (PLRootViewController *)getRootViewVC
{
    PLAppDelegate *appDelegate = (PLAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navController = (UINavigationController *)appDelegate.mainWindow.rootViewController;
    if (navController.viewControllers.count > 0) {
        PLRootViewController *rootVC = (PLRootViewController *)[navController.viewControllers objectAtIndex:0];
        return rootVC;
    }
    return nil;
}


+ (void)switchToTab:(NSInteger)tabID
{
    PLRootViewController *rootVC = [self getRootViewVC];
    [rootVC.tabBarLogic switchToTab:tabID];
}

+ (void)switchToTab:(NSInteger)tabID page:(NSInteger)pageID
{
    PLRootViewController *rootVC = [self getRootViewVC];
    [rootVC.tabBarLogic switchToTab:tabID page:pageID];
}

+ (NSString *)getRoomLogoFomatURL:(UINT32)roomId imageSize:(UINT32)size timeStamp:(UINT32)timeStamp
{
    if ([[PLAppConfigMgr shareInstance] isNormalEnv]) {
        return [NSString stringWithFormat:NSLocalizedString(@"ID_ROOM_LOGO_URL", @""), roomId, roomId,timeStamp, size];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"ID_ROOM_LOGO_URL_TEST_ENV", @""), roomId, roomId, timeStamp, size];
    }
}


+ (NSString *)getHeadBigVImageFromUrl:(NSString *)url imageSize:(INT32)size
{
    if (!url) {
        return nil;
    }
    
    NSString *imageSize;
    switch (size) {
        case 20:
            imageSize = [NSString stringWithFormat:@"bigger_%@.png", url];
            break;
        case 15:
            imageSize = [NSString stringWithFormat:@"middle_%@.png", url];
            break;
        case 10:
        case 0:
            imageSize = [NSString stringWithFormat:@"small_%@.png", url];
            break;
        default:
            break;
    }
    
    if ([[PLAppConfigMgr shareInstance] isNormalEnv]) {
        return [[NSString stringWithString:NSLocalizedString(@"ID_HEAD_BIGV_IMAGE_URL_PRIFIX", @"")] stringByAppendingString:imageSize];
    } else {
        return [[NSString stringWithFormat:NSLocalizedString(@"ID_HEAD_BIGV_IMAGE_URL_PRIFIX_TEST_ENV", @"")] stringByAppendingString:imageSize];
    }
}

+ (NSString *)getRoomPicUploadUrl
{
    if ([[PLAppConfigMgr shareInstance] isNormalEnv]) {
        return NSLocalizedString(@"ID_ROOMPIC_UPLOAD_URL", @"");
    } else {
        return NSLocalizedString(@"ID_ROOMPIC_UPLOAD_URL_TEST_ENV", @"");
    }
}


+ (NSString*)getHeadPicUploadUrl
{
    if ([[PLAppConfigMgr shareInstance] isNormalEnv]) {
        return NSLocalizedString(@"ID_HEAD_UPLOAD_URL", @"");
    } else {
        return NSLocalizedString(@"ID_HEAD_UPLOAD_URL_TEST", @"");
    }
}

+ (NSString *)stringWithSex:(SexType)sex
{
    if (sex == SexType_Female) {
        return NSLocalizedString(@"ID_PL_SEX_FEMALE", @"");
    } else if (sex == SexType_Male) {
        return NSLocalizedString(@"ID_PL_SEX_MALE", @"");
    }
    return @"";
}

+ (NSString *)getPtLoginFormatURL:(NSString *)url
{
    NSString *STR = [NSString stringWithFormat:NSLocalizedString(@"ID_PTLOGIN_FORMAT_URL", @""), url, [PLLoginMgr shareInstance].selfUid, [PLUtilApp serializationBytesToHex:[[PLLoginMgr shareInstance] getSTWebSig].sig]];
    return STR;
}

+ (NSString *)serializationBytesToHex:(NSData*)data {
    if (data == nil || data.length <= 0) {
        return @"";
    }
    Byte *testByte = (Byte *)[data bytes];


    NSMutableString *builder = [[NSMutableString alloc] init];
    for (int i = 0; i < data.length; ++i) {
        [builder appendFormat:@"%02x", (testByte[i] & 0xff)];
    }
    
    return builder;
}

+ (CGSize)getLabelSizeWithString:(NSString *)labelText font:(UIFont *)font maxLabelSize:(CGSize)maxLabelSize
{
    CGRect rect = [labelText boundingRectWithSize:CGSizeMake(maxLabelSize.width, maxLabelSize.height)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

+ (UIImage *)getSplashScreenImage
{
    NSString *imageName = nil;
    int scale = [UIScreen mainScreen].scale;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        int height = SCREEN_HEIGHT * scale;
        if (height == 960) {
            imageName = @"LaunchImage-700@2x.png";
            
        } else if (height == 1136) {
            imageName = @"LaunchImage-700-568h@2x.png";
        } else if (height == 1334) {
            imageName = @"LaunchImage-800-667h@2x.png";
        } else if (height == 2208) {
            imageName = @"LaunchImage-800-Portrait-736h@3x.png";
        } else{
            imageName = @"LaunchImage-Portrait-736h@3x.png";
        }
    }
    return [UIImage imageNamed:imageName];
}

+ (UIImage *)getNowSplashScreenImage
{
    NSString *imageName = nil;
    int scale = [UIScreen mainScreen].scale;
    LogFinal(@"PLUtilApp", @"enter getNowSplashScreenImage, userinterface:%d", UI_USER_INTERFACE_IDIOM());
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        int height = SCREEN_HEIGHT * scale;
        if (height == 960) {
            imageName = @"LaunchImageNow-700@2x.png";
            
        } else if (height == 1136) {
            imageName = @"LaunchImageNow-700-568h@2x.png";
        } else if (height == 1334) {
            imageName = @"LaunchImageNow-800-667h@2x.png";
        } else if (height == 2208) {
            imageName = @"LaunchImageNow-800-Portrait-736h@3x.png";
        } else if (height == 2436){
            // iPhoneX 在Debug和Release模式下启动图片名称不同，这里区分处理
#ifdef DEBUG
            imageName = @"LaunchImageNow-1100-Portrait-2436h@3x.png";
#else
            imageName = @"LaunchImageNow-1100-2436h@3x.png";
#endif
        } else{
            imageName = @"LaunchImageNow-800-Portrait-736h@3x.png";
        }
        LogFinal(@"PLUtilApp", @"scale:%d, height:%d, imageName:%@", scale, height, imageName);
    }
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        LogFinal(@"PLUtilApp", @"image is nil");
    }
    return image;
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSUInteger)unicodeLengthOfString:(NSString *)text
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

//emoji特殊处理
+ (NSString *)subEmojiStringToIndex:(NSUInteger)length string:(NSString *)text
{
    __block NSString  *fieldText = text;
    __block NSUInteger index = fieldText.length;
    
    __block NSUInteger count = 0;
    __block BOOL over = NO;
    [fieldText enumerateSubstringsInRange:NSMakeRange(0, [fieldText length])
                                  options:NSStringEnumerationByComposedCharacterSequences
                               usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                   if (!over) {
                                       count = count + [PLUtilApp asciiLengthOfString:substring];
                                       if (count == length*2) {
                                           index = substringRange.location+substringRange.length;
                                           over = YES;
                                       }else if (count > length*2) {
                                           count = count - [PLUtilApp asciiLengthOfString:substring];
                                           index = substringRange.location;
                                           over = YES;
                                       }
                                   }
                               }];
    fieldText = [fieldText substringToIndex:index];
    return fieldText;
}


+ (NSString *)GetDevicePlatform
{
    return [UtilMisc GetDevicePlatform];
}

+ (NSString *)GetDeviceTypeName
{
    return [UtilMisc GetDeviceTypeName];
}

+ (NSUInteger)asciiLengthOfString:(NSString *)text
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

+ (NSString *)unicodeSubstring:(NSString *)string toIndex:(NSUInteger)count
{
    NSUInteger asciiLength = 0;
    NSUInteger i;
    for (i=0; i<string.length; i++) {
        if (asciiLength >= count) {
            break;
        }
        unichar uc = [string characterAtIndex:i];
        asciiLength += isascii(uc) ? 1 : 2;
        
    }
    if (asciiLength > count) {
        i--;
    }
    return [string substringToIndex:i];
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UINT32)getUINT32WithAddressCodeStr:(NSString *)codeStr
{
    UINT32 code = 0;
    
    for (int i=0; i<MIN(codeStr.length, 4); i++) {
        code = code << 8;
        UINT8 c = [codeStr characterAtIndex:i];
        code = code | c ;
    }
    return code;
}

+ (NSString *)getStringWithAddressCodeUINT32:(UINT32)code
{
    UINT16 ls = code & 0xffff;
    UINT16 hs = code >> 16 & 0xffff;
    UINT8 hhs = hs >> 8 &0xff;
    UINT8 lhs = hs & 0xff;
    UINT8 hls = ls >> 8 & 0xff;
    UINT8 lls = ls & 0xff;
    return [NSString stringWithFormat:@"%c%c%c%c", hhs, lhs, hls,lls];
}

+ (UIImage *)imageFromCacheForUrl:(NSString *)url
{
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:nsUrl];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (image == nil) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
    
    return image;
}

+ (void)imageFromUrl:(NSString *)url callback:(void(^)(UIImage*))callback
{
    UIImage* image = [PLUtilApp imageFromCacheForUrl:url];
    if (image) {
        callback(image);
        return;
    }
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
        }
        callback(image);
    }];


}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSString *)filterEmoji:(NSString *)string{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}


+ (NSDictionary *)parseUrlParam:(NSURL *)url
{
    NSString* query = url.query;
    NSMutableDictionary* queryDic = nil;
    if (query != nil) {
        queryDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        NSScanner* scanner = [NSScanner scannerWithString:query];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString* tempString;
        while ([scanner scanUpToString:@"&" intoString:&tempString]) {
            NSRange range = [tempString rangeOfString:@"="];
            if (range.location == NSNotFound ||
                range.location == 0 ||
                range.location == [tempString length] - 1) {
                continue;
            }
            NSString* var   = [tempString substringToIndex:range.location];
            NSString* value = [tempString substringFromIndex:range.location + 1];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [queryDic setObject:value forKey:[var lowercaseString]];
        }
    }
    return queryDic;
}

+ (void)debugAlert:(NSString *)msg
{
    NSString *selfUid = [[PLLoginMgr shareInstance] selfUid];
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormatter stringFromDate:curDate];
    
    NSString *info = [NSString stringWithFormat:@"%@,uid=%@,%@", dateString, selfUid, msg];
    
    PLAlertView *alertView = [[PLAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"ID_ALERT_CANCEL", @"") otherButtonTitles:NSLocalizedString(@"ID_ALERT_OK", @""), nil];
    [alertView show];
}

+ (BOOL)isOpenPush
{
    BOOL openPush = NO;
    if (SYSTEM_VERSION >= 8.0) {
        UIUserNotificationType types = [[UIApplication sharedApplication]  currentUserNotificationSettings].types;
        openPush =  types != UIUserNotificationTypeNone;
    }else {
        UIRemoteNotificationType types;
        types = [[UIApplication sharedApplication]  enabledRemoteNotificationTypes];
        openPush = types != UIRemoteNotificationTypeNone;
    }
    return openPush;
}

+ (void)jumpToAppSystemSetting
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    UIApplication *application = [UIApplication sharedApplication];
    if (url != nil && [[UIApplication sharedApplication] canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:^(BOOL success){
                LogFinal(@"openPush", @"调用openURL:options:completionHandler:%@", success ? @"成功" : @"失败");
            }];
        } else if ([application respondsToSelector:@selector(openURL:)]) {
            BOOL bSuccess = [application openURL:url];
            LogFinal(@"openPush", @"调用openURL:%@", bSuccess ? @"成功" : @"失败");
        }
    }
}

+ (BOOL)isCheckVersion
{
    static BOOL isCheck = NO;
    static BOOL isLoad = NO;
    if (isLoad) {
        return isCheck;
    }
    LogFinal(UTILAPP_LOGFILTER, @"开始读取审核版本号");
    
    if ([LCCommonConfigMgr shareInstance].loginCommonConfigIsReady) {
        //如果已经是登录成功后拉取的配置则保存结果，避免每次调用这个函数都去读取
        isLoad = YES;
        NSString *versionCode = [[LCCommonConfigMgr shareInstance] getStringForKey:@"2300" domain:LCCommonConfigDomainType_Logining withDefault:@"0"];
        NSInteger version = [versionCode integerValue];
        LogFinal(UTILAPP_LOGFILTER, @"审核的版本号:%d", (int)version);
        
        if (version == [self getVersionCode]) {
            isCheck = YES;
        }
        else {
            isCheck = NO;
        }
        return isCheck;
    }
    else {
        //说明通用配置还没拉取回来，这个时候直接返回NO
        return NO;
    }
    
}

+ (BOOL)isIPv6
{
    return [UtilNetwork isIpV6Envir:@"203.205.151.230" port:80];
}

+ (BOOL)isHandleUrlForIpv6
{
    //提审版本才做ipv6处理
    BOOL ret = NO;
    BOOL isCheckVersion = [self isCheckVersion];
    if (isCheckVersion) {
        BOOL isIPV6 = [self isIPv6];
        ret = isIPV6;
    }
    
    static BOOL isLog = NO;
    if (!isLog) {
        isLog = YES;
        LogFinal(UTILAPP_LOGFILTER, @"isHandleUrlForIpv6，ret:%d，是否审核版本:%d", ret, isCheckVersion);
    }
    return ret;
}

+ (NSString*)handleUrlForIpv6:(NSString*)url
{
    //可能不止这一个域名， 明天找后台确认
    if (url == nil) {
        return url;
    }
    LogFinal(UTILAPP_LOGFILTER, @"handleUrlForIpv6:sourceUrl= %@", url);
    NSURL* nsUrl = [[NSURL alloc] initWithString:url];
    NSString* destUrl = url;
    //ipv4暂时没转成ipv6的
    if ([nsUrl.host isEqualToString:@"p.qpic.cn"]) {
        NSRange rang = [destUrl rangeOfString:nsUrl.host];
        destUrl = [url stringByReplacingCharactersInRange:rang withString:[NSString stringWithFormat:@"[%@]", [UtilNetwork getHostString:@"203.205.151.219" port:80]]];
    } else if ([nsUrl.host isEqualToString:@"shp.qlogo.cn"]) {
        NSRange rang = [destUrl rangeOfString:nsUrl.host];
        destUrl = [url stringByReplacingCharactersInRange:rang withString:[NSString stringWithFormat:@"[%@]", [UtilNetwork getHostString:@"203.205.151.229" port:80]]];
    } else if ([nsUrl.host isEqualToString:@"p.qlogo.cn"] || [nsUrl.host isEqualToString:@"pic.url.cn"]) {
        NSRange rang = [destUrl rangeOfString:nsUrl.host];
        destUrl = [url stringByReplacingCharactersInRange:rang withString:[NSString stringWithFormat:@"[%@]", [UtilNetwork getHostString:@"203.205.151.230" port:80]]];
    } else if ([nsUrl.host isEqualToString:@"8.url.cn"]) {
        NSRange rang = [destUrl rangeOfString:nsUrl.host];
        destUrl = [url stringByReplacingCharactersInRange:rang withString:@"now.qq.com/img"];
    } else {
        //正则表达式替换ip地址为ipv6
        static NSRegularExpression *urlRegularExpression = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            urlRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)(:\\d{0,5})?" options:NSRegularExpressionCaseInsensitive error:nil];
        });
        
        NSArray *ips = [urlRegularExpression matchesInString:url
                                                     options:NSMatchingWithTransparentBounds
                                                       range:NSMakeRange(0, [url length])];
        if (ips == nil || ips.count == 0) {
            return url;
        }
        NSTextCheckingResult *result = [ips firstObject];
        NSString *ipAndPort = [url substringWithRange:result.range];
        if (ipAndPort == nil || ipAndPort.length == 0) {
            return url;
        }
        NSRange seperate = [ipAndPort rangeOfString:@":" options:NSBackwardsSearch];
        NSString* ipv4 = nil;
        int port = 80;
        if (seperate.length == 0) {
            ipv4 = ipAndPort;
            port = 80;
        } else {
            ipv4 = [ipAndPort substringToIndex:seperate.location];
            port = [[ipAndPort substringFromIndex:seperate.location + 1] intValue];
        }
        NSString* ipv6 = [UtilNetwork getHostString:ipv4 port:port];
        NSString* ipv6Url = [url stringByReplacingOccurrencesOfString:ipAndPort withString:[NSString stringWithFormat:@"[%@]:%d", ipv6, port]];
        LogFinal(UTILAPP_LOGFILTER, @"handleUrlForIpv6:sourceUrl= %@, sourceIp = %@, ipv6 = %@, port = %d, ipv6Url = %@", url, ipv4, ipv6, port, ipv6Url);
        destUrl = ipv6Url;
    }
    
//    if (![[PLATSUtil shareInstance] isATSClosed] && ![PLATSUtil isDomain:destUrl] && [destUrl hasPrefix:@"https://"]) {
        destUrl = [destUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
//    }
    
    LogFinal(UTILAPP_LOGFILTER, @"handleUrlForIpv6:destUrl = %@", destUrl);
    return destUrl;
}

+ (id)queryValueFromMiscOffline:(NSString*)key
{
    static BOOL showLog = NO;
    NSString *configFilePath = [QQOfflineWebApp getOfflineFilePathWithBid:@"2322" name:@"misc_ios.json"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:configFilePath]) {
        NSString* content = [NSString stringWithContentsOfFile:configFilePath encoding:NSUTF8StringEncoding error:nil];
        if (!showLog) {
            LogFinal(UTILAPP_LOGFILTER, @"读取的内容是：\n%@",content);
            showLog = YES;
        }
        
        NSData *retData = [content dataUsingEncoding:NSUTF8StringEncoding];
        if (!retData) {
            return NULL;
        }
        NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableLeaves error:nil];
        if(!configDict || ![configDict isKindOfClass:[NSDictionary class]]) {
            LogFinal(UTILAPP_LOGFILTER, @"json的内容不为字典");
            return NULL;
        }
        id value = [configDict objectForKey:key];
        return value;
    }
    LogFinal(UTILAPP_LOGFILTER, @"misc_ios.json不存在");
    return NULL;
}

+ (BOOL)isHorizontalScreen
{
    return UIInterfaceOrientationMaskLandscapeRight == [[[PLUtilApp currentNavigationController].viewControllers lastObject] supportedInterfaceOrientations];
}


+ (NSInteger)getHomePageAutoPlayIndexForMutilView
{
    static NSInteger retValue = -1;
    
    if (retValue == -1) {
        NSString* value = (NSString*)[PLUtilApp queryValueFromMiscOffline:@"homepage"];
        return [value integerValue];
    }
    
    return  retValue;
}

+ (NSString*)giftResUrl:(NSString*)giftPath
{
    if (!giftPath || giftPath.length == 0) {
        return nil;
    }
     NSString *resUrl = nil;
    if ([PLUtilApp isHandleUrlForIpv6]) {
        resUrl = [NSString stringWithFormat:NSLocalizedString(@"ID_PL_ROOM_GIFT_RES_IPV6", @""), giftPath];
    } else {
        resUrl = [NSString stringWithFormat:NSLocalizedString(@"ID_PL_ROOM_GIFT_RES", @""), giftPath];
    }
    return resUrl;
}
@end
