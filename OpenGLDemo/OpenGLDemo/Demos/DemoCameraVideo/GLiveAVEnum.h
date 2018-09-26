//Created by applechang on 2017/5/13.

#ifndef GLIVE_AV_ENUM_H__
#define GLIVE_AV_ENUM_H__

#import "QAVCommon.h"

enum
{
    GLIVEAV_ERROR_SSO_DECODE = -20170513,             //命令字不支持
};

typedef NS_ENUM(NSInteger, GLiveSessionStatus){
    GLiveStatus_Default = 0,    //默认
    GLiveStatus_StartLive = 1,  // 发起直播
    GLiveStatus_Living,         // 直播中
    GLiveStatus_LiveStop,       // 直播结束
    GLiveStatus_PlayBack,       // 直播回看
    GLiveStatus_WatchLive,      // 观众观看直播
};

typedef NS_ENUM(NSInteger, GLiveAVRole){
    GLiveRoleNone,
    GLiveRoleHost = 1,
    GLiveRoleAudience = 2,
};

typedef NS_ENUM(NSInteger, GLiveAudioCategory){
    GLIVE_AUDIO_CATEGORY_REALTIME = 0,
    GLIVE_AUDIO_CATEGORY_PLAY,
    GLIVE_AUDIO_CATEGORY_WATCH,
    GLIVE_AUDIO_CATEGORY_HIGH_QUALITY,
};

typedef NS_ENUM(NSInteger, eGLiveCameraResolution){
    CAMERA_PRESET_NONE    = -1,
    CAMERA_PRESET_320x240 =0,
    CAMERA_PRESET_640x480,
    CAMERA_PRESET_960x540,
    CAMERA_PRESET_1280x720,
};

typedef NS_ENUM(NSInteger, eGLiveCameraDirection){
    CAMERA_DIRECTION_FRONT= 0,
    CAMERA_DIRECTION_BACK = 1,
};

typedef NS_ENUM(NSInteger, eGLiveAVFluidCtrlRole){
    AV_FLUID_CTRL_ROLE_BIGGEST    = 0,
    AV_FLUID_CTRL_ROLE_BIGGER     = 1,
    AV_FLUID_CTRL_ROLE_SMALL      = 2,
    AV_FLUID_CTRL_ROLE_AUDIENCE   = 3,
};


typedef NS_ENUM(NSInteger, eGLiveVideoSrcType) {
    GLIVE_VIDEO_SRC_TYPE_NONE   = QAVVIDEO_SRC_TYPE_NONE,     ///< 默认值，无意义
    GLIVE_VIDEO_SRC_TYPE_CAMERA = QAVVIDEO_SRC_TYPE_CAMERA,   ///< 摄像头
    GLIVE_VIDEO_SRC_TYPE_SCREEN = QAVVIDEO_SRC_TYPE_SCREEN,   ///< 屏幕分享
    GLIVE_VIDEO_SRC_TYPE_MEDIA  = QAVVIDEO_SRC_TYPE_MEDIA,    ///< 播片
};


/*!
 @discussion    音视频事件更新
 */
typedef NS_ENUM(NSInteger, GLiveAVUpdateEvent) {
    GLIVE_EVENT_ID_NONE                          = QAV_EVENT_ID_NONE,///< 默认值，无意义。
    GLIVE_EVENT_ID_ENDPOINT_ENTER                = QAV_EVENT_ID_ENDPOINT_ENTER,///< 进入房间事件。
    GLIVE_EVENT_ID_ENDPOINT_EXIT                 = QAV_EVENT_ID_ENDPOINT_EXIT, ///< 退出房间事件。
    GLIVE_EVENT_ID_ENDPOINT_HAS_CAMERA_VIDEO     = QAV_EVENT_ID_ENDPOINT_HAS_CAMERA_VIDEO, ///< 有发摄像头视频事件。
    GLIVE_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO      = QAV_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO, ///< 无发摄像头视频事件。
    GLIVE_EVENT_ID_ENDPOINT_HAS_AUDIO            = QAV_EVENT_ID_ENDPOINT_HAS_AUDIO, ///< 有发语音事件。
    GLIVE_EVENT_ID_ENDPOINT_NO_AUDIO             = QAV_EVENT_ID_ENDPOINT_NO_AUDIO, ///< 无发语音事件。
    GLIVE_EVENT_ID_ENDPOINT_HAS_SCREEN_VIDEO     = QAV_EVENT_ID_ENDPOINT_HAS_SCREEN_VIDEO, ///< 有发屏幕视频事件。
    GLIVE_EVENT_ID_ENDPOINT_NO_SCREEN_VIDEO      = QAV_EVENT_ID_ENDPOINT_NO_SCREEN_VIDEO, ///< 无发屏幕视频事件。
    GLIVE_EVENT_ID_ENDPOINT_HAS_MEDIA_FILE_VIDEO = QAV_EVENT_ID_ENDPOINT_HAS_MEDIA_FILE_VIDEO, ///< 有发文件视频事件。
    GLIVE_EVENT_ID_ENDPOINT_NO_MEDIA_FILE_VIDEO  = QAV_EVENT_ID_ENDPOINT_NO_MEDIA_FILE_VIDEO, ///< 无发文件视频事件。
};

typedef NS_ENUM(NSInteger, eGLiveAVControlBits){
    GLIVE_AV_CONTROL_BIT_DOING_ANIMATION    = 1<<0,
};

#endif /* GLIVE_AV_ENUM_H__ */
