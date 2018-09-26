//
//  PLAccumulateTimer.m
//  HuaYang
//
//  Created by Andre on 16/9/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PLAccumulateTimer.h"
#import "NoRetainTimer/NoRetainTimer.h"

@interface PLAccumulateTimer ()
@property(nonatomic, assign) NSUInteger      maxNums;
@property(nonatomic, assign) NSTimeInterval recvTime;
@property(nonatomic, assign) NSTimeInterval showTime;
@property(nonatomic, strong) NoRetainTimer  *timerForShow;
@property(nonatomic, strong) NoRetainTimer  *timerForRecv; //
@property(nonatomic, strong) NSMutableArray *accumulateArray;
@property(nonatomic, weak)   id<PLAccumulateTimerDelegate> delegate;
@end

@implementation PLAccumulateTimer
- (id)initWithMaxNums:(NSUInteger)nums recvTime:(NSTimeInterval)recvTime showTime:(NSTimeInterval)showTime delegate:(id<PLAccumulateTimerDelegate>)delegate;
{
    if (self = [super init]) {
        self.maxNums = nums;
        self.recvTime = recvTime;
        self.showTime = showTime;
        self.delegate = delegate;
        self.accumulateArray = [NSMutableArray arrayWithCapacity:self.maxNums];
    }
    return self;
}

- (void)dealloc
{
    if (self.timerForRecv) {
        [self.timerForRecv invalidate];
        self.timerForRecv = nil;
    }
    
    if (self.timerForShow) {
        [self.timerForShow invalidate];
        self.timerForShow = nil;
    }
    self.delegate = nil;
}

- (void)accumulate:(id)object force:(BOOL)force
{
    if (![NSThread isMainThread]) {
        LogDev(@"PLAccumulateTimer", @"在子线程新加入对象%@", object);
        __weak PLAccumulateTimer* weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf internalAccumulate:object force:force];
        });
    } else {
        [self internalAccumulate:object force:force];
    }
    
}

- (void)internalAccumulate:(id)object force:(BOOL)force
{
    if (object) {
        if (self.timerForRecv) {
            [self.timerForRecv invalidate];
            self.timerForRecv = [NoRetainTimer scheduledTimerWithTimeInterval:self.recvTime target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
        } else {
            self.timerForRecv = [NoRetainTimer scheduledTimerWithTimeInterval:self.recvTime target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
        }
        
        if (!self.timerForShow) {
            self.timerForShow = [NoRetainTimer scheduledTimerWithTimeInterval:self.showTime target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        }
        [self.accumulateArray addObject:object];
    }
    
    if (force) {
        [self callBack];
    }
}

- (void)callBack
{
    if (self.accumulateArray.count > 0) {
        LogDev(@"PLAccumulateTimer", @"accumulateArray = %lu", self.accumulateArray.count);
        NSMutableArray* array = nil;
        if (self.accumulateArray.count > self.maxNums) {
            array = [NSMutableArray arrayWithCapacity:self.maxNums];
            for (NSInteger index = self.accumulateArray.count - self.maxNums; index < self.accumulateArray.count; index++) {
                [array addObject:[self.accumulateArray objectAtIndex:index]];
            }
        } else {
            array = [NSMutableArray arrayWithArray:self.accumulateArray];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAccumulateTimer:)]) {
            [self.delegate onAccumulateTimer:array];
        }
        [self.accumulateArray removeAllObjects];
    }
}

- (void)onTimer:(NoRetainTimer*)timer
{
    if (timer == _timerForRecv) {
        _timerForRecv = [NoRetainTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }
    [self callBack];
}
@end
