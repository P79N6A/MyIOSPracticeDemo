//
//  PLUtilText.m
//  HuaYang
//
//  Created by mirageqliu on 15/12/14.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import "PLUtilText.h"
#import <arpa/inet.h>

@implementation PLUtilText

+ (NSString*) ip2Str:(unsigned int)ip
{
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = ip;
    addr.sin_port = 0;
    
    char *chost = inet_ntoa(addr.sin_addr);
    NSString *host = [NSString stringWithUTF8String:chost];
    return host;
}

+ (unsigned int) str2Ip:(NSString*)host
{
    return inet_addr([host cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
