#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IIMWebMsg.h"
#import "IFalcoBlock.h"
#import "IAppCoreData.h"

#define kFalcoIMC2CMsgEventName @"FalcoIMC2CMsgEvent"
#define kFalcoIMBigGroupMsgEventName @"FalcogIMBigGroupMsgEvent"

#define kFalcoIMC2CKickedEventName @"FalcoIMC2CKickedEvent"
#define kFalcoIMBigGroupKickedEventName @"FalcoIMBigGroupKickedEvent"

#define kFalcoIMBigLongPollingFailed @"FalcoIMBigLongPollingFailed"

typedef NS_ENUM(NSInteger, FalcoIMWebFSM){
    FCIMWEB_FSM_UNINIT  = 600000,                      //未初始化状态
    FCIMWEB_FSM_INIT    = 600001,                      //初始化状态
    FCIMWEB_FSM_DOING   = 600002,                      //IMSDK登录
    FCIMWEB_FSM_END     = 600003,                      //登录结束
};

typedef NS_ENUM(NSInteger, FalcoIMWebErrorCode){
    FCIMWEB_EC_OK = 0,                           //成功
    FCIMWEB_EC_LOGIN_RET_EMPTY          = 6100000, //登录CGI返回空
    FCIMWEB_EC_LOGIN_DATA_EMPTY         = 6100001, //登录必要信息为空
    FCIMWEB_EC_LONG_POLLING_ID_FAIL     = 6100002, //获取P2Pl轮询ID失败
    FCIMWEB_EC_JOIN_BIG_GROUP_ID_EMPTY  = 6100003, //请求进群群号为空
    FCIMWEB_EC_CGI_RET_EMPTY            = 6100004, //CGI请求返回空
};

@protocol IIMWebMsgDelegate <IFalcoObject>
-(void)onRecvC2CMsg:(id<IIMWebMsg>)c2cMsg;
-(void)onRecvGroupMsg:(id<IIMWebMsg>)groupMsg;
@end

@protocol IIMWebPushCmdDelegate <IFalcoObject>
//-(void)onRecvPushCmd:(uint32_t)cmd withData:(NSData *)data;
-(void)onRecvPushCmd:(NSData *)data;
@end

@protocol IIMWebProxy <IFalcoObject>
@required
-(void)setCoreData:(id<IAppCoreData>)coreData;
-(void)login:(id<IFalcoBlock>)resultBlock;
-(void)appExit;
-(void)sendMessage:(id<IIMWebMsg>)imWebMsg resultBlock:(id<IFalcoBlock>)resultBlock;
-(void)syncC2CMessage:(NSString*)cookie withBlock:(id<IFalcoBlock>)resultBlock; //同步消息
-(void)syncC2CMsgReaded:(NSMutableArray*)readedMsgList
             withCookie:(NSString*)cookie
              withBlock:(id<IFalcoBlock>)resultBlock; //上报IMService

-(uint64_t)getIMTinyId;
-(void)setIMTinyId:(uint64_t)tinyId;

-(void)regIMWebMsgMonitor:(id<IIMWebMsgDelegate>)monitor;
-(void)unRegIMWebMsgMonitor:(id<IIMWebMsgDelegate>)monitor;

-(void)regPushCmdMonitor:(id<IIMWebPushCmdDelegate>)monitor;
-(void)unRegPushCmdMonitor:(id<IIMWebPushCmdDelegate>)monitor;

-(void)applyJoinBigGroup:(NSString*)groupId
                applyMsg:(NSString*)applyMsg
        userDefinedField:(NSString*)userDefinedField
             resultBlock:(id<IFalcoBlock>)resultBlock;

-(void)quitBigGroup:(NSString*)groupId
        resultBlock:(id<IFalcoBlock>)resultBlock;
@end



