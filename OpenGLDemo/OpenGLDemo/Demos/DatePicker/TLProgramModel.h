//
//  TLProgramModel.h
//  TencentLive
//
//  Created by nickyhuang on 2019/1/22.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TLProgramType) {
    TLProgramTypeUnknow = 1,                                //
    TLProgramTypeVideo = 2,                                 // 视频直播
    TLProgramTypeVoice = 3,                                 // 语音直播
    TLProgramTypeNULL = 4,                                  // 预留
};

typedef NS_ENUM(NSUInteger, TLProgramStatus) {
    TLProgramStatusUnknow = 1,                              //
    TLProgramStatusWait = 2,                                // 未开播
    TLProgramStatusLive = 3,                                // 正在开播
    TLProgramStatusEnd = 4,                                 // 直播结束
    TLProgramStatusCancel = 5,                              // 直播取消
    TLProgramStatusDirect = 6,                              // 任性直播中（无直播计划）
    TLProgramStatusNull = 7,                                // 预留
};



@interface TLProgramInfoModel : NSObject

@property (nonatomic, assign) TLProgramType type;                                              //直播类型
@property (nonatomic, strong) NSString *strTitle;                                              //直播计划名字
@property (nonatomic, assign) UINT32 uint32StartTs;                                            //直播计划开始时间戳,单位s
@property (nonatomic, strong) NSString *strDesc;                                               //直播计划描述
@property (nonatomic, strong) NSMutableArray *rptStrCoverArr;                                  //直播计划封面
@property (nonatomic, assign) UINT32 uint32EndTs;                                              //直播结束时间,单位s
@property (nonatomic, assign) UINT32 uint32CancelTs;                                           //直播取消时间,单位s
@property (nonatomic, assign) UINT32 uint32ShowNum;                   //预约人数，另外协议拉取

@end

@interface TLProgramVideoModel : NSObject


@end

@interface TLProgramVoiceModel : NSObject


@end



@interface TLProgramModel : NSObject

@property (nonatomic, strong) NSString *strProgramId;                                          //直播场id, ProgramKey序列化hex编码
@property (nonatomic, assign) TLProgramType type;                                                //直播类型
@property (nonatomic, assign) TLProgramStatus status;                                            //直播状态
@property (nonatomic, assign) UINT64 uint64Uid;                                                //创建用户uid
@property (nonatomic, assign) UINT64 uint64RoomId;                                             //房间id
@property (nonatomic, assign) UINT32 uint32ClientType;                                         //创建客户端类型
@property (nonatomic, assign) UINT32 uint32ClientVersion;                                      //创建客户端版本
@property (nonatomic, strong) TLProgramInfoModel *programInfo;                                 //
@property (nonatomic, strong) TLProgramVideoModel *typeVideo;                                  //
@property (nonatomic, strong) TLProgramVoiceModel *typeVoice;                                  //


@end

NS_ASSUME_NONNULL_END
