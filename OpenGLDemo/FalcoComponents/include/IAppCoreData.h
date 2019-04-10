#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IBizAccountInfo.h"

typedef NS_ENUM(NSInteger, FalcoAppFSMStatus) {
    FalcoAppFSMStatus_Init   = 1,          //初始状态
    FalcoAppFSMStatus_BizLoging = 2,       //业务登录中
    FalcoAppFSMStatus_BizLoginFail = 3,    //业务登录失败
    FalcoAppFSMStatus_IMWebLoging = 4,     //IMWebSDK登录中
    FalcoAppFSMStatus_IMWebLoginFail = 5,  //IMWebSDK登录结束
    FalcoAppFSMStatus_Complete = 6         //状态机处于完成状态
};

typedef NS_ENUM(NSInteger, FalcoAppFSMErrorCode) {
    FalcoAppFSMError_NONE   = 0,                     //无错误
    FalcoAppFSMError_BizLoginFail   = 100001,        //业务登录失败
    FalcoAppFSMError_IMWebLoginFail = 200001,        //IMWeb登录失败
};

@protocol IAppCoreData <IFalcoObject>
@required
-(FalcoAppFSMStatus)getAppFSMStatus;
-(void)setAppFSMStatus:(FalcoAppFSMStatus)status;

-(void)setUin:(uint64_t)uin;
-(uint64_t)getUin;

-(void)setSkey:(NSString*)skey;
-(NSString*)getSkey;
-(NSString*)getSSOPrefix;

-(int)getTXCloudAppId;
-(int)getClientType;
-(int)getAccountType;
-(int)getApn;
-(int)getIdType;
-(int)getKeyType;
-(BOOL)getIsTestEnv;
-(uint64_t)getFalcoAppId;
-(uint64_t)getUid;
-(void)setUid:(uint64_t)uid;
-(NSString*)getBizUserSig;
-(void)setBizUserSig:(NSString*)userSig;


//业务账号信息
-(id<IBizAccountInfo>)getBizAccInfo;
-(void)setBizAccInfo:(id<IBizAccountInfo>)bizAccInfo;
@end

