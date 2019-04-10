//
//  FalcoObserver.m
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/17.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "FalcoObserver.h"

/*
 
 //模板一
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wprotocol"
 
 Falco_OBSERVER_IMPLEMENT(DemoObserver)
 
  #pragma clang diagnostic pop
 
 //模板二s
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wprotocol"
 @implementation TestObserver
 @end
 #pragma clang diagnostic pop
 */


@interface FalcoObserver ()

@property(atomic, strong) NSPointerArray *delegates;
@property(atomic, strong) NSLock *lock;

@end

@implementation FalcoObserver
{
    BOOL _needClean;    //是否需要清理
    BOOL _waitClean;    //即将清理等待中
}

//OCS_CLASS_DYNAMIC_FLAG

- (void)dealloc
{
    self.delegates = nil;
    self.lock = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.delegates = [NSPointerArray weakObjectsPointerArray];
        self.lock = [[NSLock alloc] init] ;
        _needClean = NO;
        _waitClean = NO;
    }
    return self;
}

- (void)addObserverDelegate:(id)delegate
{
    [self.lock lock];
    for (NSUInteger i = 0; i < self.delegates.count; i++) {
        id tDelegate = [self.delegates pointerAtIndex:i];
        if (tDelegate) {
            if (tDelegate == delegate) {
                [self.lock unlock];
                return;
            }
        }else{
            _needClean = YES;
        }
    }
    [_delegates addPointer:(__bridge void *)(delegate)];
    [self.lock unlock];
    [self checkNeedClean];
}

- (void)removeObserverDelegate:(id)delegate
{
    [self.lock lock];
    for (NSUInteger i = 0; i < self.delegates.count; i++) {
        id tDelegate = [self.delegates pointerAtIndex:i];
        if (tDelegate) {
            if (tDelegate == delegate) {
                [self.delegates removePointerAtIndex:i];
                break;
            }
        }else{
            _needClean = YES;
        }
    }
    [self.lock unlock];
    [self checkNeedClean];
}

//对消息进行分发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self];
    }
    
    NSPointerArray *delegatesCopy = nil;
    [self.lock lock];
    delegatesCopy = [self.delegates copy];
    [self.lock unlock];
    
    for (NSUInteger i = 0; i < delegatesCopy.count; i++) {
        id tDelegate = [delegatesCopy pointerAtIndex:i];
        if (tDelegate) {
            if ([tDelegate respondsToSelector:anInvocation.selector]) {
                [anInvocation invokeWithTarget:tDelegate];
            }
        }else{
            //需要清理
            _needClean = YES;
        }
    }
    //[self checkNeedClean];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if(sig) return sig;
    
    for (NSUInteger i = 0; i < self.delegates.count; i++) {
        NSObject *tDelegate = [self.delegates pointerAtIndex:i];
        if (tDelegate) {
            sig = [tDelegate.class instanceMethodSignatureForSelector:aSelector];
            if(sig) return sig;
        }
    }
    
    //完全找不到人实现的方法，避免crash，给它返回一个可以找到的空方法
    return [FalcoObserver instanceMethodSignatureForSelector:@selector(blankCall)];
}

//一个可以被instanceMethodSignatureForSelector找到的空方法
- (void)blankCall
{
    
}

- (void)checkNeedClean
{
    if (!_needClean) {
        return;
    }
    
    if (_waitClean) {
        return;
    }
    
    _waitClean = YES;
    
    [self performSelector:@selector(cleanInvalidObserver) withObject:nil afterDelay:0.2];
}

- (void)cleanInvalidObserver
{
    [self.lock lock];
    for (NSUInteger i = 0; i < self.delegates.count; i++) {
        id tDelegate = [self.delegates pointerAtIndex:i];
        if (!tDelegate) {
            [self.delegates removePointerAtIndex:i];
        }
    }
    [self.lock unlock];
    _waitClean = NO;
    _needClean = NO;
}

@end
