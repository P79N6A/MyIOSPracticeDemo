#import "FalcoUtilMisc.h"

@implementation FalcoUtilMisc
+(NSDictionary *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt
{
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    
    NSData* data = nil;
    NSError* error = nil;
    data = [NSJSONSerialization dataWithJSONObject:obj options:opt error:&error];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (data) result[@"data"] = data;
    if (error) result[@"error"] = error;
    return result;
}

+(NSDictionary *)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt
{
    if (data == nil) {
        return nil;
    }
    
    id json = nil;
    NSError* error = nil;
    json = [NSJSONSerialization JSONObjectWithData:data options:opt error:&error];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (json) result[@"data"] = json;
    if (error) result[@"error"] = error;
    return result;
}

+(void)dispatchAfterWhen:(dispatch_time_t)when
                   queue:(dispatch_queue_t)queue
                   block:(id<IFalcoBlock>)resultBlock
{
    if (!resultBlock) {
        return;
    }
    dispatch_after(when, queue, ^{
        [resultBlock callWith:nil];
    });
}
@end
