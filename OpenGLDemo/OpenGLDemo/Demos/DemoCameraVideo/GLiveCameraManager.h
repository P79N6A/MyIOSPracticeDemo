//  Created by applechang on 2017-5-12.
//  Copyright © 2016年 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, GLiveCameraAvailableState){
    GLiveCameraNonAvailable,         // 无摄像头可用
    GLiveCameraOneAvailable,         // 仅有一个摄像头可用
    GLiveCameraBothAvailable,        // 全部摄像头可用
};

//@interface GLiveCameraSampleBuffer : NSObject
//
//- (instancetype)initWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
//
//- (BOOL)doCosmetic; //美颜
//
//- (void)setDataToVideoFrame:(QAVVideoFrame*)videoFrame;
//#ifdef QZLV_TEMP
//- (NSData *)data;
//+ (NSData *)dataFromVideoFrame:(QAVVideoFrame*)videoFrame;
//#endif
//@end

@interface GLiveCameraManager : NSObject
{
}

@property (nonatomic, assign) NSInteger         cameraFps;

/**
 *  是否支持闪光灯
 *
 *  @return YES:支持  NO:不支持
 */
+ (BOOL)isEnableLED:(AVCaptureDevicePosition)cameraPosition;

/**
 *  闪光灯是否打开
 *
 *  @return YES:打开  NO:关闭
 */
+ (BOOL)isLEDOn:(AVCaptureDevicePosition)cameraPosition;

/**
 *  开启/关闭闪光灯
 *
 *  @param on YES:开启  NO:关闭
 *
 *  @return YES:成功  NO:失败
 */
+ (BOOL)turnLED:(BOOL)on cameraPosition:(AVCaptureDevicePosition)cameraPosition;

/**
 *  前置摄像头是否存在
 *
 *  @return YES:存在  NO:不存在
 */
+ (BOOL)isFrontCameraExist;

/**
 *  后置摄像头是否存在
 *
 *  @return YES:存在  NO:不存在
 */
+ (BOOL)isBackCameraExist;

/**
 *  检查摄像头可用状态
 *
 *  @return 可用数目（枚举类型）
 */
+ (GLiveCameraAvailableState)cameraAvailableState;

/**
 *  init
 *
 *  @return instance
 */
- (instancetype)initWithDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate;

/**
 *  获取摄像头位置
 *
 *  @return 摄像头位置
 */
- (AVCaptureDevicePosition)cameraPosition;

// front YES:前置 NO:后置
/**
 *  切换摄像头
 *
 *  @param front YES:前置 NO:后置
 *
 *  @return 是否成功
 */
- (BOOL)switchCamera:(BOOL)front;

/**
 *  设置摄像头采集帧率
 *
 *  @param cameraFps 采集帧率
 */
- (void)setCameraFps:(NSInteger)cameraFps;

/**
 *  设置摄像头分辨率
 *
 *  @param width
 *  @param height
 *
 *  @return 是否成功
 */
- (BOOL)setCameraResolutionWidth:(NSInteger)width height:(NSInteger)height;

/**
 *  打开摄像头
 *
 *  @return YES:成功  NO:失败
 */
- (BOOL)startSession;

/**
 *  关闭摄像头
 */
- (void)stopSession;

/**
 *  根据一个点来聚焦
 *
 *  @param point 聚焦的点
 *
 *  @return YES:成功  NO:失败
 */
- (BOOL)focusAtPoint:(CGPoint)point;
@end
