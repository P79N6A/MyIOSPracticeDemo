//  Created by applechang on 2018/11/12.
//  Copyright © 2018年 applechang. All rights reserved.

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define FALCO_ASSERT(condition, desc, ...)   NSAssert(condition, desc,  ##__VA_ARGS__)
#else
#define FALCO_ASSERT(condition, desc, ...)
#endif

@interface FalcoUtilCore<ObjectType> : NSObject

+(BOOL)LaunchFalcoClassEngine:(NSString*)coreXmlPath;

+(ObjectType)CreateObject:(NSString *)iid;
+(Class)GetObjectClass:(NSString *)iid;

+(ObjectType)GetService:(NSString *)iid withClsid:(NSString *)clsid;

@end

@interface FalcoUtilType<ObjectType> : NSObject
+(ObjectType)Cast:(id)rawType;
@end

