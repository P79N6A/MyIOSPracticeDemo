//
//  PLUtilApp.h
//  HuaYang
//
//  Created by xenayang on 15/11/20.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLTabBarController.h"
#import "PLUserInfoModel.h"
#import "PLViewController.h"
#import "PLHomePageDef.h"
#import "PLRootTabBarLogic.h"

@interface PLUtilApp : NSObject
// webview请求url时处理url，此处是避免系统缓存导致离线失效之用
+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url;
+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withTimeStamp:(UINT64)timeStamp;
+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withBid:(int)bid;
+ (NSString *)urlAppendForOvercomeCache:(NSURL *)url withParam:(NSString *)paramName value:(UINT64)value;
/*
 * 获取app版本，不带build号，比如1.1.2,
 */
+ (NSString*)getBundleVersionsStringShort;

/*
 *获取app版本，带build号，比如1.1.2.59
 */
+ (NSString*)getBundleVersion;
+ (NSString*)getBundleID;

/*
 * 获取协议版本号
 */
+ (NSInteger)getVersionCode;

/*
 * 获取当前viewcontroller
 */
+ (UIViewController*)currentViewController;

/*
 *获取App的TabBarController
 */
+ (PLTabBarController*)appTabBarController;

/*
 *获取App当前的NavigationController
 */
+ (UINavigationController*)currentNavigationController;


/*
 *在当前UINavigationController栈中从栈顶开始查找指定类名，指定hash值的viewController
 *className：指定类名
 *hash：指定的hash值（一直可在viewcontroller中重载指定）
 *maxLevel：表示最多查找多少层
 */
+ (PLViewController*)findViewController:(NSString*)className hash:(NSUInteger)hash maxLevel:(NSUInteger)level;

/*
 *获取房间头像的url
 */
+ (NSString *)getRoomLogoFomatURL:(UINT32)roomId imageSize:(UINT32)size timeStamp:(UINT32)timeStamp;

/*
 *获取user大V图片的url
 */
+ (NSString *)getHeadBigVImageFromUrl:(NSString *)url imageSize:(INT32)size;

/*
 *获取图片上传cgi（房间封面）
 */
+ (NSString *)getRoomPicUploadUrl;

/*
 *获取图片上传cgi（房间封面）
 */
+ (NSString *)getHeadPicUploadUrl;


/*
 *性别汉化
 */
+ (NSString *)stringWithSex:(SexType)sex;

/*
 *获取uilabel的高度
 */
+ (CGSize)getLabelSizeWithString:(NSString *)labelText font:(UIFont *)font maxLabelSize:(CGSize)maxLabelSize;

/*
 *获取启动画面图片
 */
+ (UIImage *)getSplashScreenImage;
+ (UIImage *)getNowSplashScreenImage;

+ (NSString *)getPtLoginFormatURL:(NSString *)url;

+ (NSString *)serializationBytesToHex:(NSData*)data;

//判断字符串中是否都为数字
+ (BOOL)isPureInt:(NSString *)string;

/*
 *获取字符数
 */
+ (NSUInteger)unicodeLengthOfString: (NSString *) text;
+ (NSUInteger)asciiLengthOfString:(NSString *)text;

/*
 *根据字符数截取：一个汉字俩字符，一个数字一个字符
 */
+ (NSString *)unicodeSubstring:(NSString *)string toIndex:(NSUInteger)count;
/*
 *根据字符数截取：一个汉字俩字符，一个数字一个字符,对emoji做特殊处理
 */
+ (NSString *)subEmojiStringToIndex:(NSUInteger)length string:(NSString *)text;

/*
 *返回设备类型的字符串，如iphone5
 */
+ (NSString *)GetDevicePlatform;

/*
 *返回设备类型的字符串，如iphone5
 */
+ (NSString *)GetDeviceTypeName;

/*
 *图片缩放
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
/*
 *地址码转换
 */
+ (UINT32)getUINT32WithAddressCodeStr:(NSString *)codeStr;
/*
 *地址码转换
 */
+ (NSString *)getStringWithAddressCodeUINT32:(UINT32)code;

/*
 *通过url获取缓存的图片，如果没有缓存，则返回nil
 */
+ (UIImage *)imageFromCacheForUrl:(NSString *)url;

/*
 *通过url获取图片，先从缓存中取， 如果没有缓存，则从网络下载
 */
+ (void)imageFromUrl:(NSString *)url callback:(void(^)(UIImage*))callback;

/*
 *是否含有emoji
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/*
 *解析URL里面的参数
 */
+ (NSDictionary *)parseUrlParam:(NSURL *)url;

//只为打印调试错误信息
+ (void)debugAlert:(NSString *)msg;

/*
 *是否设置了接收push
 */
+ (BOOL)isOpenPush;
/*
 *跳转到app的系统设置页面
 */
+ (void)jumpToAppSystemSetting;
/*
 *判断是否为审核版本
 */
+ (BOOL)isCheckVersion;

/*
 *是否ipv6环境
 */
+ (BOOL)isIPv6;

/*
 *是否对URL做IPv6转换
 */
+ (BOOL)isHandleUrlForIpv6;

/*
 *对特定的域名做用固定ip的ipv6替换
 */
+ (NSString*)handleUrlForIpv6:(NSString*)url;

/*
 *根据key从2322离线包misc中读取相应的value
 */
+ (id)queryValueFromMiscOffline:(NSString*)key;

+ (NSString *)filterEmoji:(NSString *)string;

+ (BOOL)isHorizontalScreen;

//多行显示时，自动播放哪一个。 -1 默认值，不播， 1 左边的， 2 右边的。
- (NSInteger)getHomePageAutoPlayIndexForMutilView;

/*
 *根据tabID, pageID跳到对应的tab与page，如果pageID不存在，则跳默认首个tab的首个page
 */
+ (void)switchToTab:(NSInteger)tabID;
+ (void)switchToTab:(NSInteger)tabID page:(NSInteger)pageID;

/*
 *拼接获取礼物图片地址， 会区分iPV6且是审核版本情况
 */
+ (NSString*)giftResUrl:(NSString*)giftPath;
@end
