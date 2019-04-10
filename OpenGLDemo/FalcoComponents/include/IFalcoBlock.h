#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSDictionary.h>
#import <UIKit/UIKit.h>
#import "IFalcoComponent.h"

@protocol IFalcoResult;

typedef void (^pfnFalcoBlock)(id<IFalcoResult> falcoResult);

@protocol IFalcoBlock <IFalcoObject>
@required
-(void)initWith:(pfnFalcoBlock)block;

//参数回调 id<IFalcoResult>
-(void)initWith:(SEL)selector target:(id)target userInfo:(NSDictionary*)userInfo;
-(NSMutableDictionary*)getUserInfo;
-(void)setUserInfo:(NSDictionary*)userInfo;
-(void)setOutBlock:(id<IFalcoBlock>)outBlock;
-(id<IFalcoBlock>)getOutBlock;

- (void)callWith:(id)retValue;
- (void)callWithErr:(NSError *)err retValue:(id)retValue;
@end


@protocol IFalcoResult <IFalcoObject>

- (void)setData_Error:(NSError *)error
             retValue:(id)retValue
             userInfo:(NSDictionary *)userInfo
             outBlock:(id<IFalcoBlock>)outBlock;

// 错误信息
-(NSError *)error;
// 结果
-(id)retValue;
// 透传数据
-(NSMutableDictionary *)userInfo;
// outBlock--链路上层的block
-(id<IFalcoBlock>)outBlock;

@end

