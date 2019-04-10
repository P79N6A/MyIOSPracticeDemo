//  Created by applechang on 2018/11/12.
//  Copyright © 2018年 applechang. All rights reserved.

#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

// for object

#define DECLARE_COM_MAP() \
    -(id<IFalcoObject>)ComObjectContructor:(NSString *)iid;

#define BEGIN_COM_MAP() \
    -(id<IFalcoObject>)ComObjectContructor:(NSString *)iid{

#define COM_INTERFACE_ENTRY(i, c) \
    NSString* ns##i = [NSString stringWithUTF8String: #i];\
    if ([iid isEqualToString:ns##i]){\
    id<IFalcoObject> temp = [c new];\
    return temp;}\

#define END_COM_MAP() \
    return [super ComObjectContructor:iid];}\



// for static class

#define DECLARE_COMCLASS_MAP() \
    -(Class)ComObjectClass:(NSString *)iid;

#define BEGIN_COMCLASS_MAP() \
    -(Class)ComObjectClass:(NSString *)iid{

#define COMCLASS_INTERFACE_ENTRY(i, c) \
    NSString* ns##i = [NSString stringWithUTF8String: #i];\
    if ([iid isEqualToString:ns##i]){\
    return NSClassFromString(c);}\

#define END_COMCLASS_MAP() \
    return [super ComObjectClass:iid];}\


@interface FalcoComponentRoot : NSObject<IFalcoClassFactory,IFalcoComponent>
    DECLARE_COM_MAP()
    DECLARE_COMCLASS_MAP()
@end

