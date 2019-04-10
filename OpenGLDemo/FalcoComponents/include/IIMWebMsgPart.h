#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"

typedef NS_ENUM(NSInteger, IMWebMsgPartType) {
    kIMWebMsgPartType_CUSTOM    = 1,
    kIMWebMsgPartType_FACE      = 2,
    kIMWebMsgPartType_TEXT      = 3,
    kIMWebMsgPartType_AUDIO     = 4,
};

@protocol IIMWebMsgPart <IFalcoObject>
@required
-(IMWebMsgPartType)getMsgType;
-(void)setMsgType:(IMWebMsgPartType)type;
@end

@protocol IIMWebMsgPartCustom <IIMWebMsgPart>
@required
-(void)initCustomMsgPart:(NSString *)customData desc:(NSString *)desc ext:(NSString *)ext;
-(NSString*)getCustomData;
-(NSString*)getCustomDesc;
-(NSString*)getCustomExt;
@end

@protocol IIMWebMsgPartAudio <IIMWebMsgPartCustom>
@required
-(void)initAudioMsgPart:(NSString *)customData ext:(NSString *)ext;
@end

@protocol IIMWebMsgPartFace <IIMWebMsgPart>
@required
-(void)initFaceMsgPart:(NSNumber*)index data:(NSString*)faceData;
-(NSString*)getFaceData;
-(NSNumber*)getIndex;
@end

@protocol IIMWebMsgPartText <IIMWebMsgPart>
@required
-(void)initTextMsgPart:(NSString *)text;
-(NSString*)getText;
@end
