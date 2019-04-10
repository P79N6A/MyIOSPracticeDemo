#import <Foundation/Foundation.h>
#import "IFalcoBlock.h"

@interface FalcoUtilMisc:NSObject
+(NSDictionary *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt;
+(NSDictionary *)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt;
+(void)dispatchAfterWhen:(dispatch_time_t)when
                   queue:(dispatch_queue_t)queue
                   block:(id<IFalcoBlock>)resultBlock;
@end
