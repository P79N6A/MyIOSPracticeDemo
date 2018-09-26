//Created by applechang
//detail: 用来做CPU，内存监控的,临时代码只给群视频使用
//Copyright (c) 2017/11/27 applechang. All rights reserved.
#import <Foundation/Foundation.h>

@protocol GLiveCPUMonitorDelegate <NSObject>

@optional

/**
 * 监控过程中CPU耗时超过阈值连续n次后捕捉到的各线程cpu耗时和堆栈情况
 *
 * @param cpuUsageLogs 每个时间片各线程cpu耗时情况，以||分隔
 * @param backtraceLogs 每个时间片各线程堆栈情况，以,\\n    分隔
 */
- (void)didCaptureUsageLog:(NSArray *)cpuUsageLogs andBacktraceLog:(NSArray *)backtraceLogs;

@end

@interface GLiveCPUMonitor : NSObject

@property (nonatomic, assign) NSUInteger lastFrequency;
@property (nonatomic, assign) double cpuThresholdInPercent;
@property (nonatomic, assign) NSUInteger monitorIntervalInSecond;
@property (nonatomic, weak) id<GLiveCPUMonitorDelegate> monitorDelegate;

+ (GLiveCPUMonitor *)shareInstance;
- (void)startMonitor;
- (void)stopMonitor;
- (BOOL)isMonitoring;

@end

