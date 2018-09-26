//Created by applechang
//detail: 通用音视频控件,暂时只给群使用
//Copyright (c) 2018/1/15 applechang. All rights reserved.
#import <UIKit/UIKit.h>
#import "GLRender.h"

@protocol GLiveMp4RenderViewDelegate <NSObject>
//-(void)onFirstFrameRecv:(uint64_t)roomId identifier :(uint64_t)uid withFrameDesc:(QAVFrameDesc*)frameDesc;
//-(void)onEndpointUpdateEvent:(GLiveAVUpdateEvent)event identifier:(uint64_t)uid;
@end

//@protocol IGLiveRenderView <NSObject>
//@required
//- (void)setMp4VideoFrame:(void *)videoFrame;
////- (void)drawVideoFrame;
////- (void)clearVideoFrame;
////- (void)setControlBits:(eGLiveAVControlBits)ctrlBit withSwitch:(BOOL)on;
//- (CFTimeInterval)lastFrameTime; //上一帧的时间
//@end

@interface GLiveMp4RenderView : UIView
{
    EAGLContext*           _context;
    CAEAGLLayer*           _eaglLayer;
    GLuint                 _colorRenderBuffer; // 渲染缓冲区
    GLuint                 _frameBuffer;       // 帧缓冲区
    CGFloat                _yRotateAngle;
    CGFloat                _xRotateAngle;
    CGFloat                _zRotateAngle;
    
    GLint           _backingWidth;
    GLint           _backingHeight;
    
    CGRect                 _rcViewport;
    CGSize                 _videoFrameSize;
    CGSize                 _viewSize;
    GLiveGLRender*         _render;
    uint32_t               _ctrlBits;
    
    uint32_t               _sequence;//渲染帧数统计
    CFTimeInterval         _lastFrameTime;   //上一帧的时间
    
    CGFloat                _contentScale;    //内容scale
}

@property (nonatomic, weak)id<GLiveMp4RenderViewDelegate> renderViewDelegate;
@property(atomic,strong) NSRecursiveLock *glActiveLock;
@property(atomic) BOOL glActivePaused;
@property(nonatomic)        CGFloat  scaleFactor;
- (void)setMp4VideoFrame:(CVPixelBufferRef)pixelBuffer;
- (void)setTexture:(GLTexture *)texture;
@end
