#import <Foundation/Foundation.h>

@interface NSDictionary (FalcoUtil)
- (NSArray*)safeAccessArrayForKey:(NSString*)key;
- (NSString*)safeAccessStringForKey:(NSString*)key;
- (NSNumber*)safeAccessNumberForKey:(NSString*)key;
- (NSDictionary*)safeAccessDictForKey:(NSString*)key;
@end
