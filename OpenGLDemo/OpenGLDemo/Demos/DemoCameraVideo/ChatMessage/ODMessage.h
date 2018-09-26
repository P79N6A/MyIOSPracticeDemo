//
// Created by jichao on 2017/4/27.
// Copyright (c) 2017 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ODGetAValue(argb) (unsigned char)((argb) >> 24)
#define ODGetRValue(argb) (unsigned char)((argb) >> 16)
#define ODGetGValue(argb) (unsigned char)((argb) >> 8)
#define ODGetBValue(argb) (unsigned char)(argb)

//将ARGB转换成UIColor
#define ODARGB2UICOLOR(A,R,G,B) [UIColor colorWithRed:(R / 255.0) green:(G / 255.0) blue:(B / 255.0) alpha:(A / 255.0)]
#define ODRGB2UICOLOR(R,G,B)  [UIColor colorWithRed:(R / 255.0) green:(G / 255.0) blue:(B / 255.0) alpha:1.0]

#define ODARGB2UICOLOR2(argb) [UIColor colorWithRed:(ODGetRValue((argb)) / 255.0) green:(ODGetGValue((argb)) / 255.0) blue:(ODGetBValue((argb)) / 255.0) alpha:(ODGetAValue((argb)) / 255.0)]
#define ODRGB2UICOLOR2(rgb) [UIColor colorWithRed:(ODGetRValue((rgb)) / 255.0) green:(ODGetGValue((rgb)) / 255.0) blue:(ODGetBValue((rgb)) / 255.0) alpha:1.0]
#define ODRGBA2UICOLOR(rgb, a) [UIColor colorWithRed:(ODGetRValue((rgb)) / 255.0) green:(ODGetGValue((rgb)) / 255.0) blue:(ODGetBValue((rgb)) / 255.0) alpha:a]
#define ODRGBA2NAUICOLOR(R,G,B,A) [UIColor colorWithRed:(R / 255.0) * A  green:(G / 255.0) * A blue:(B / 255.0) * A  alpha:1]
#define ODZRGBA2UICOLOR(R,G,B,A) [UIColor colorWithRed:(R / 255.0) green:(G / 255.0) blue:(B / 255.0) alpha:A]

#define OD_ONE_PIXEL_SPACEING  (([[UIScreen mainScreen] scale] >= 1) ? (1.0 / [[UIScreen mainScreen] scale]) : 1.0)


#define OD_COLOR_RED ODRGB2UICOLOR(255, 79, 116)

typedef NS_ENUM(NSInteger, ODChatBoardMsgType) {
    kODMessageType_C2C          = 1,
    kODMessageType_GROUP        = 2,
    kODMessageType_BigGroup     = 3,
    kODMessageType_GiftPresent  = 4,
};

@interface ODPush : NSObject

@property (nonatomic, assign) uint32_t command;
@property (nonatomic, retain) NSData *data;

- (id)initWithCmd:(uint32_t)cmd data:(NSData *)data;

@end

@interface ODMessage : NSObject
@property (nonatomic, assign) ODChatBoardMsgType messageType;
@property (nonatomic, assign) bool isSendMsg;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray* nativeRep;
@property (nonatomic, strong) NSDictionary* jsonRep;
@property (nonatomic, strong) NSString* toUid;
@property (nonatomic, strong) NSString* toNick;
@property (nonatomic, strong) NSString* fromUid;
@property (nonatomic, strong) NSString* fromNick;
@end

@interface ODPresentGiftMsg : ODMessage
@property (nonatomic, strong) NSString* giftImgPath;
@property (nonatomic, strong) NSString* giverIdentityImgPath;
@property (nonatomic, strong) NSString* receiverIdentityImgPath;
@property (nonatomic, assign) NSUInteger giftset;
@property (nonatomic, assign) NSUInteger combo;
@end
