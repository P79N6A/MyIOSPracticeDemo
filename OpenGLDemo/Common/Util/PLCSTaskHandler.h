//
//  PLCSTaskHandler.h
//  HuaYang
//
//  Created by Orange on 2017/11/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PLCSTaskCode) {
    PLCSTaskCode_Success = 0,
    PLCSTaskCode_Timeout = 1,
    PLCSTaskCode_Other   = 2,
};

typedef void(^RequestFinishedBlock)(NSString *result, NSInteger code);

@interface PLCSTaskHandler : NSObject
+ (void)requestWithParams:(NSDictionary *)params andFinishedBlock:(RequestFinishedBlock)finishedBlock;
- (void)objectRequestWithParams:(NSDictionary *)params andFinishedBlock:(RequestFinishedBlock)finishedBlock;
@end
