#import "NSDictionary+FalcoUtil.h"

@implementation NSDictionary (FalcoUtil)

- (NSArray *)safeAccessArrayForKey:(NSString*)key {
    if (!key)
        return nil;
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSArray class]] ? val : nil;
}

- (NSString *)safeAccessStringForKey:(NSString*)key
{
    if(!key)
        return nil;
    
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSString class]] ? val : nil;
}

- (NSNumber *)safeAccessNumberForKey:(NSString*)key
{
    if(!key)
        return nil;
    
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSNumber class]] ? val : nil;
}

- (NSDictionary *)safeAccessDictForKey:(NSString*)key
{
    if(!key)
        return nil;
    
    id val = [self objectForKey:key];
    return [val isKindOfClass:[NSDictionary class]] ? val : nil;
}
@end




