//
//  FalcoObserver.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/17.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFalcoObserver.h"

@interface FalcoObserver : NSObject<IFalcoObserver>
@end


#define Falco_OBSERVER_ADD_DEFINE(ClassNameDelegate) \
- (void)addObserverDelegate:(id<ClassNameDelegate>)delegate;

//快速定义开始（类名）
#define Falco_OBSERVER_BEGIN(ClassName)  \
@class ClassName;   \
@protocol ClassName##Delegate<NSObject> \

//快速定义结束（类名）
#define Falco_OBSERVER_END(ClassName) \
@end \
@interface ClassName : FalcoObserver <ClassName##Delegate> \
@end

//快速定义实现（类名）
#define Falco_OBSERVER_IMPLEMENT(ClassName)    \
@implementation ClassName   \
@end


///////////////////////////////////////
////////////    模板一    //////////////
///////////////////////////////////////

/*
 Falco_OBSERVER_BEGIN(FalcoDemoObserver)
 
 //这里添加方法
 - (NSString *)demoFunc:(NSObject *)object;
 
 Falco_OBSERVER_END(ODDemoObserver)
 
 */

///////////////////////////////////////
////////////    模板二    //////////////
///////////////////////////////////////

/*
 
 @protocol FalcoTestObserverDelegate<NSObject>
 @optional
 OD_OBSERVER_ADD_DEFINE(FalcoTestObserverDelegate)
 
 //这里添加方法
 - (NSString *)testFunc:(NSObject *)test;
 
 @end
 
 @interface ODTestObserver : ODObserver <ODTestObserverDelegate>
 @end
 
 */
