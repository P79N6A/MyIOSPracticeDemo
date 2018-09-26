//
//  PLAccumulateTimer.h
//  HuaYang
//
//  Created by Andre on 16/9/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PLAccumulateTimerDelegate <NSObject>
- (void)onAccumulateTimer:(NSArray*)array;
@end

@interface PLAccumulateTimer : NSObject
/*
 *初始化累积计时器
 *nums:累积个数
 *recvTime:累积间隔时间
 *showTime：最多累积时间
 *delegate：处理delegate
 */
- (id)initWithMaxNums:(NSUInteger)nums recvTime:(NSTimeInterval)recvTime showTime:(NSTimeInterval)showTime delegate:(id<PLAccumulateTimerDelegate>)delegate;

/*
 *累积方法
 *object：要累积的对象
 *force：是否强制刷新当次累积
 */
- (void)accumulate:(id)object force:(BOOL)force;
@end
