#import "FalcoLogUtil.h"
#import "IFalcoLog.h"
#import "FalcoUtilCore.h"

@implementation FalcoLogUtil
+(void)logFinal:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3)
{
    if (format == nil) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString* desc = [[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    Class<IFalcoLog> falcoLogClass = [FalcoUtilCore GetObjectClass:@"IFalcoLog"];
    [falcoLogClass log_Final:module msg:desc];
}

+ (void)logDye:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3)
{
    if (format == nil) {
        return;
    }
    Class<IFalcoLog> falcoLogClass = [FalcoUtilCore GetObjectClass:@"IFalcoLog"];
    va_list args;
    va_start(args, format);
    NSString* desc = [[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [falcoLogClass log_Dye:module msg:desc];
}

+ (void)logDev:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3)
{
    if (format == nil) {
        return;
    }
    Class<IFalcoLog> falcoLogClass = [FalcoUtilCore GetObjectClass:@"IFalcoLog"];
    
    va_list args;
    va_start(args, format);
    NSString* desc = [[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [falcoLogClass log_Dye:module msg:desc];
}

+ (void)logDebug:(NSString *)module withFormat:(NSString *)format,... NS_FORMAT_FUNCTION(2,3)
{
    if (format == nil) {
        return;
    }
    Class<IFalcoLog> falcoLogClass = [FalcoUtilCore GetObjectClass:@"IFalcoLog"];
    
    va_list args;
    va_start(args, format);
    NSString* desc = [[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [falcoLogClass log_Debug:module msg:desc];
}
@end
