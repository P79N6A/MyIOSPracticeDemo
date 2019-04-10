#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IFalcoBlock.h"
#import "IAppCoreData.h"
#import "IWebSSOChannel.h"

typedef NS_ENUM(NSInteger, FalcoBizLoginErrorCode){
    FCBIZLOGIN_EC_SUCC = 0,                           //成功
    FCBIZLOGIN_EC_FAIL_UNINIT  =  50001001,           //业务登录未初始化参数
    FCBIZLOGIN_EC_FAIL_DECODE  =  50001002,           //返回数据解码失败
    FCBIZLOGIN_EC_FAIL_UNKNOWN =  50001003,           //业务登录失败
};

@protocol IFalcoBizLogin <IFalcoObject>
@required
-(void)setCoreData:(id<IAppCoreData>)coreData
       withChannel:(id<IWebSSOChannel>)webSSOChannel;
- (FalcoBizLoginErrorCode)getErrorCode;
-(void)login:(id<IFalcoBlock>)resultBlock;
@end
