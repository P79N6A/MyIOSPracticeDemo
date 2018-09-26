//
//  PLUtilUserAgent.h
//  HuaYang
//
//  Created by Andre on 2018/3/20.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLUtilUserAgent : NSObject
/*
 *获取UIWebView的userAgent，并附加自定义字段
 *目前加的通用字段" Now/APP版本号_系统版本 IPV6 SCHEMER 当前网络"
 *例如：" Now/850_11.20 IPV6 tnow NetType/WIFI"
 *后续业务附加自定义字段建议" key/value"形式
 */
+ (NSString*)getUserAgent;
@end
