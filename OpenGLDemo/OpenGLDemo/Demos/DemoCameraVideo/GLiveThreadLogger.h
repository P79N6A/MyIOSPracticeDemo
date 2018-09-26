#import <Foundation/Foundation.h>

@interface GLiveThreadLogger : NSObject
+ (instancetype)shareInstance;
- (NSString *)logOfAllThread;
- (double)currentCpuUsageForTask;
- (double)currentMemoryForTask;
- (NSString *)logOfAllThreadUsage;
- (NSArray *)getThreadsStack;
- (NSArray *)getThreadsCPUUsage;
- (void)prepare;

@end

