//Created by applechang on 2017/5/13.

#ifndef GLIVE_AV_ENUM_H__
#define GLIVE_AV_ENUM_H__

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

typedef enum eGLiveVideoRotateAxis
{
    GLive_Rotation_Axis_X,
    GLive_Rotation_Axis_Y,
    GLive_Rotation_Axis_Z,
    
}GLIVE_VIDEO_ROTATE_AXIS;

typedef enum eGLiveVideoRotateType
{
    GLive_Rotation_Type_Vertex,
    GLive_Rotation_Type_Texture,
    
}GLIVE_VIDEO_ROTATE_TYPE;

typedef NS_ENUM(NSInteger, eGLiveCameraResolution){
    CAMERA_PRESET_NONE    = -1,
    CAMERA_PRESET_640x480 = 0,
    CAMERA_PRESET_960x540,
    CAMERA_PRESET_1280x720,
};

typedef NS_ENUM(NSInteger, eGLiveCameraDirection){
    CAMERA_DIRECTION_FRONT= 0,
    CAMERA_DIRECTION_BACK = 1,
};

#endif /* GLIVE_AV_ENUM_H__ */
