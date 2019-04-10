#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IFalcoBlock.h"
#import "IAppCoreData.h"

typedef NS_ENUM(NSInteger, FalcoWebSSOChannelErrorCode){
    FCWEBSSO_CHANNEL_EC_SUCC             = 0,                  //成功
    FCWEBSSO_CHANNEL_EC_RET_EMPTY        =  40001001,          //CSchannel返回空
    FCWEBSSO_CHANNEL_EC_DECODE_FAIL      =  40001002,          //CSchannel解包失败
    FCWEBSSO_CHANNEL_EC_OPENSSO_ERROR    =  40001003,          //CSchannelOpenSSO Error
    FCWEBSSO_CHANNEL_EC_NET_ERROR        =  40001004,          //CSchannel网络错误
};

@protocol IWebSSOChannel <IFalcoObject>
@required
-(void)setCoreData:(id<IAppCoreData>)coreData;
- (void)sendData:(NSData *)data
             cmd:(uint32_t)cmd
          subCmd:(uint32_t)subCmd
    timeoutInSec:(NSInteger)seconds
     resultBlock:(id<IFalcoBlock>)resultBlock;

- (void)sendData:(NSData *)data
       ssoPrefix:(NSString *)ssoPrefix
             cmd:(uint32_t)cmd
          subCmd:(uint32_t)subCmd
    timeoutInSec:(NSInteger)seconds
     resultBlock:(id<IFalcoBlock>)resultBlock;
@end
