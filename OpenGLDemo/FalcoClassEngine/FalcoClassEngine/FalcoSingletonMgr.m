#import "FalcoSingletonMgr.h"

@interface FalcoSingletonMgr()

@property (nonatomic, strong)NSMutableDictionary *dict;

@end

@implementation FalcoSingletonMgr
+ (instancetype)shareInstance
{
    static FalcoSingletonMgr* g_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_sharedInstance = [[FalcoSingletonMgr alloc] init];
    });
    return g_sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)singletonForName:(NSString*)name
{
    if (!name || [name length] == 0){
        return nil;
    }
    return [_dict objectForKey:name];
}

- (void)setSingleton:(id)singleton forName:(NSString*)name
{
    if (!name || [name length] == 0) {
        return;
    }
    
    if (!singleton) {
        return;
    }
    [_dict setObject:singleton forKey:name];
}

@end
