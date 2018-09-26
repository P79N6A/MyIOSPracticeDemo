//
//  PLUtilText.h
//  HuaYang
//
//  Created by mirageqliu on 15/12/14.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLUtilText : NSObject

+ (NSString*)ip2Str:(unsigned int)ip;
+ (unsigned int)str2Ip:(NSString*)host;
@end
