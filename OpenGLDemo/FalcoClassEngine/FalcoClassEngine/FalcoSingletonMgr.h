#import <Foundation/Foundation.h>

@interface FalcoSingletonMgr : NSObject
+ (instancetype)shareInstance;
- (id)singletonForName:(NSString*)name;
- (void)setSingleton:(id)singleton forName:(NSString*)name;
@end
