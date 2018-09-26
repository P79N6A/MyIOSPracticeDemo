//
//  PLUtilJoinGourp.m
//  HuaYang
//
//  Created by test on 2017/3/31.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "PLUtilJoinGourp.h"

@implementation PLUtilJoinGourp

+(BOOL)openQQGroup:(NSString*)groupUin{
    NSString* urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=@""&card_type=group&source=external",groupUin];
    NSURL* url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    
    return NO;
}

@end
