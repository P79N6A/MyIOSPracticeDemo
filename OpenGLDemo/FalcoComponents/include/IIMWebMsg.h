#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IIMWebMsgPart.h"

typedef NS_ENUM(NSInteger, IMWebMsgType) {
    kIMWebMsgType_C2C          = 1,
    kIMWebMsgType_GROUP        = 2,
    kIMWebMsgType_BigGroup     = 3,
    kIMWebMsgType_GiftPresent  = 4,
};

#define kSender_CustomElemDesc     @"MIF2"
#define kAudio_CustomElemDesc      @"AudioRes"
#define kS2CPush_CustomElemDesc    @"S2C"

@protocol IIMWebMsg <IFalcoObject>
@required

-(NSString*)getImRoomId;
-(void)setImRoomId:(NSString*)roomId;

-(IMWebMsgType)getMsgType;
-(void)setMsgType:(IMWebMsgType)msgType;

-(uint64_t)getFromUid;
-(void)setFromUid:(uint64_t)uid;

-(NSString*)getFromNick;
-(void)setFromNick:(NSString*)fromNick;

-(uint64_t)getToUid;
-(void)setToUid:(uint64_t)uid;

-(NSString*)getToBigGroupId;
-(void)setToBigGroupId:(NSString*)groupId;

-(NSString*)getToNick;
-(void)setToNick:(NSString*)nick;

-(NSDictionary*)getAvatarInfo;
-(void)setAvatarInfo:(NSDictionary*)avatar;

-(long)getMsgSeq;
-(void)setMsgSeq:(long)seq;

-(long)getTimeStamp;
-(void)setTimeStamp:(long)time;

-(long)getRandomNumber;
-(void)setRandomNumber:(long)number;

-(NSDictionary*)getRespJson;
-(void)setRespJson:(NSDictionary*)respJson;

-(NSMutableArray*)getNativeMsgElements;

-(NSMutableArray*)getPushCmdList;

-(NSDictionary*)serilizeToMsgPack;
-(BOOL)deserilizeFromMsgPack:(NSDictionary*)dicJson;

-(void)addPushCmdElem:(NSString*)data
                 desc:(NSString*)desc
                  ext:(NSString*)ext;

-(id<IIMWebMsgPartText>)addTextElem:(NSString*)text;

-(id<IIMWebMsgPartFace>)addFaceElem:(NSNumber*)index
                               data:(NSString*)data;

-(id<IIMWebMsgPartCustom>)addCustomElem:(NSString*)data
                                   desc:(NSString*)desc
                                    ext:(NSString*)ext;
-(id<IIMWebMsgPartAudio>)addAudioElem:(NSString*)data
                                   ext:(NSString*)ext;


@end



