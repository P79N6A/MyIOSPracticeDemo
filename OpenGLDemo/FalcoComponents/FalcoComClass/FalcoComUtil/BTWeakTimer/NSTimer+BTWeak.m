#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "NSTimer+BTWeak.m"
#pragma clang diagnostic pop


//
//  NSTimer+BTWeak.m
//  HuaYang
//
//  Created by britayin on 2017/5/23.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "NSTimer+BTWeak.h"

@implementation NSTimer (BTWeak)

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)yesOrNo
{
    __weak typeof(aTarget) weakTarget = aTarget;
    return [self timerWithTimeInterval:ti target:weakTarget selector:aSelector userInfo:nil repeats:yesOrNo];
}

+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)yesOrNo
{
    __weak typeof(aTarget) weakTarget = aTarget;
    return [self scheduledTimerWithTimeInterval:ti target:weakTarget selector:aSelector userInfo:nil repeats:yesOrNo];
}

+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end
