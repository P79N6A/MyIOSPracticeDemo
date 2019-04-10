#import <Foundation/Foundation.h>

@interface FalcoLogUtil:NSObject
+(void)logFinal:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3);
+(void)logDye:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3);
+(void)logDev:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3);
+(void)logDebug:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3);
@end
