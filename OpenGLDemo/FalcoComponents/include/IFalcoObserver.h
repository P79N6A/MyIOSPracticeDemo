//
//  IFalcoObserver.h
//  FalcoComponents
//
//  Created by Carly 黄 on 2019/1/8.
//  Copyright © 2019年 Carly 黄. All rights reserved.
//
//  保证所有delegate 都是week，并且任意增删安全。
//

#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@protocol IFalcoObserver<IFalcoObject>

@required
- (void)addObserverDelegate:(id)delegate;
- (void)removeObserverDelegate:(id)delegate;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;

@end
