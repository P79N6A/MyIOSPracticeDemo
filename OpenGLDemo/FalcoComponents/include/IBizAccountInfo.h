#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"

@protocol IBizAccountInfo <IFalcoObject>

@required
- (uint64_t)uin;
- (void)setUin:(uint64_t)uin;
- (NSString *)userName;
- (void)setUserName:(NSString *)userName;
- (uint64_t)tinyId;
- (void)setTinyId:(uint64_t)tinyId;
- (BOOL)isNewUser;
- (void)setIsNewUser:(BOOL)isNewUser;
- (NSString *)userSig;
- (void)setUserSig:(NSString *)userSig;
- (NSString *)a2Key;
- (void)setA2Key:(NSString *)a2Key;
- (uint32_t)sigExpire;
- (void)setSigExpire:(uint32_t)sigExpire;
- (uint64_t)severTime;
- (void)setSeverTime:(uint64_t)severTime;
- (NSData *)ex;
- (void)setEx:(NSData *)ex;
@end

