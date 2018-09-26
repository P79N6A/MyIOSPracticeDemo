//
//  YYSentinel.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __has_include("YYDispatchQueuePool.h")
#import "YYDispatchQueuePool.h"
#else
#import <libkern/OSAtomic.h>
#endif

/// Global display queue, used for content rendering.
static dispatch_queue_t YYAsyncLayerGetDisplayQueue() {
#ifdef YYDispatchQueuePool_h
    return YYDispatchQueueGetForQOS(NSQualityOfServiceUserInitiated);
#else
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.ibireme.yykit.render", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.ibireme.yykit.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) cur = -cur;
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
#endif
}

//static dispatch_queue_t YYAsyncLayerGetReleaseQueue() {
//#ifdef YYDispatchQueuePool_h
//    return YYDispatchQueueGetForQOS(NSQualityOfServiceDefault);
//#else
//    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//#endif
//}

/**
 YYSentinel is a thread safe incrementing counter. 
 It may be used in some multi-threaded situation.
 */
@interface YYSentinel : NSObject

/// Returns the current value of the counter.
@property (atomic, readonly) int32_t value;

/// Increase the value atomically.
/// @return The new value.
- (int32_t)increase;

@end
