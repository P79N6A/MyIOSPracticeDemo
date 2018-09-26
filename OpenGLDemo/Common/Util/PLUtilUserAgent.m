//
//  PLUtilUserAgent.m
//  HuaYang
//
//  Created by Andre on 2018/3/20.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "PLUtilUserAgent.h"
#import "PLUtilApp.h"
#import <Network/Util/UtilNetwork.h>

@implementation PLUtilUserAgent

+ (NSString*)getUserAgent
{
    if (![NSThread isMainThread]) {
#if FINAL_RELEASE == 0
        NSAssert(false, @"%s must be called on main thread.", __FUNCTION__);
#endif
        return @"";
    }
    
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if (userAgent == nil) {
        userAgent = @"iOS";
    }
    if ([userAgent rangeOfString:@" Now/"].location == NSNotFound) {
        userAgent = [userAgent stringByAppendingFormat:@" Now/%ld_%.2f%@ %@", (long)[PLUtilApp getVersionCode], SYSTEM_VERSION, [PLUtilApp isIPv6] ? @" ipv6" : @"", NOW_URL_SCHEMERS];
    }
    userAgent = [self appendNetTypeStr:userAgent];
    
    return userAgent;
}

#pragma mark - NetType

+ (NSString *)appendNetTypeStr:(NSString *)originalUserAgent {
    
    if (originalUserAgent.length <= 0) return originalUserAgent;
    
    NSString *originalStr = originalUserAgent;
    NSString *netTypeStr = [self netTypeStr];
    
    NSString *appendStr = [NSString stringWithFormat:@" NetType/%@", netTypeStr];
    NSString *resultStr = nil;
    if ([originalStr rangeOfString:@"NetType/"].location == NSNotFound) {
        resultStr = [originalStr stringByAppendingString:appendStr];
    } else {
        // static NSString *regExpStr = @" NetType/[0-9a-zA-Z\\u4e00-\\u9fa5]+ ";
        // 这里简单处理，枚举匹配下
        static NSString *regExpStr = @" NetType/(\\wG|WIFI|Unreachable|Unknown)";
        resultStr = [originalStr stringByReplacingOccurrencesOfString:regExpStr
                                                           withString:appendStr
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, originalStr.length)];
    }
    return resultStr;
}

/**
 NetType/WIFI            // Wifi网络下
 NetType/4G              // 运营商网络：4G
 NetType/3G              // 运营商网络：3G
 NetType/2G              // 运营商网络：2G
 NetType/XG              // 运营商网络：不知道几G的非wifi网络都返回这个
 NetType/Unreachable     // 网络不可达
 NetType/Unknown         // 未知，保留值
 */
+ (NSString *)netTypeStr {
    
    switch ([UtilNetwork netType]) {
        case NetworkTypeWifi:
            return @"WIFI";
            
        case NetworkType4G:
            return @"4G";
            
        case NetworkType3G:
            return @"3G";
            
        case NetworkType2G:
            return @"2G";
            
        case NetworkTypeXG:
            return @"XG";
            
        case NetworkTypeNotReach:
            return @"Unreachable";
            
        case NetworkTypeUnknown:
        default:
            return @"Unknown";
    }
    return @"Unknown";
}

@end
