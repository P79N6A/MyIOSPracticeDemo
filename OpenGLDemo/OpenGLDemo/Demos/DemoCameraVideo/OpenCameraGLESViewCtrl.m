//
//  DemoDrawImageOpenGLES.m
//  OpenGLDemo
//
//  Created by Chris Hu on 16/1/10.
//  Copyright © 2016年 Chris Hu. All rights reserved.
//
#import "OpenCameraGLESViewCtrl.h"
#import <AVFoundation/AVFoundation.h>
#import "OpenCameraGLESView.h"
#import "GLiveCameraManager.h"
#import "GLiveGLShareInstance.h"
#import "GiftPlayView.h"

#define MAXSCALE 2.0 //最大缩放比例
#define MINSCALE 0.5 //最小缩放比例

@interface OpenCameraGLESViewCtrl ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    CGRect              _frameCAEAGLLayer;
    OpenCameraGLESView *_viewDrawImage;
    
    CGRect              _frameCAEAGLLayer1;
    OpenCameraGLESView *_viewDrawImage1;
    
    GLiveCameraManager* _cameraManager;
    dispatch_queue_t    _cellLayoutQueue;
    UIButton*           _playBtn;
    BOOL                _bPauseVideoStream;
    GifitPlayView*      _mp4PlayView;
}

@property (nonatomic) UIImage *originImage;
@property (nonatomic) UIImageView *originImageView;
@property (nonatomic, assign) CGFloat totalScale;

@end

@implementation OpenCameraGLESViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    double discount = pow(2, -1);
    self.totalScale = 1;
    //int width = self.view.frame.size.width;
    //int height = self.view.frame.size.height;
    _frameCAEAGLLayer = CGRectMake(50, 100, 200, 200);
    //_frameCAEAGLLayer = self.view.bounds;
    _viewDrawImage = [[OpenCameraGLESView alloc] initWithFrame:_frameCAEAGLLayer withHighResolution:YES];
    _viewDrawImage.viewTag = 1;
    _viewDrawImage.userInteractionEnabled = YES;
    _viewDrawImage.multipleTouchEnabled = YES;
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleGLRenderView:)];
    [_viewDrawImage addGestureRecognizer:gesture];
    
//    _frameCAEAGLLayer1 = CGRectMake(100, 400, 200, 200);
//    _viewDrawImage1 = [[OpenCameraGLESView alloc] initWithFrame:_frameCAEAGLLayer1 withHighResolution:YES];
//    _viewDrawImage1.viewTag = 2;
//    _viewDrawImage1.userInteractionEnabled = YES;
//    _viewDrawImage1.multipleTouchEnabled = YES;
    
    typedef int (^blk_t)(int);
    
    for (int rate=0; rate<10; ++rate) {
        blk_t blk = ^(int count){return rate*count;};
        NSLog(@"applechangtest blk ptr: %llu", (unsigned long long)blk);
    }
    
    [self.view addSubview:_viewDrawImage];
    [self.view addSubview:_viewDrawImage1];
    
    CGSize size;
//    size.width =  640;
//    size.height = 480;
    
    //_cellLayoutQueue = dispatch_queue_create("OpenCameraGLDemo", DISPATCH_QUEUE_SERIAL);
    
    _playBtn = [[UIButton alloc] init];
    
    
    _playBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, 80, 30);
    [_playBtn setTitle:@"播放豪华礼物" forState:UIControlStateNormal];
    [_playBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(onPlayLuxuryGift) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.layer.cornerRadius = 10;
    _playBtn.layer.masksToBounds = YES;
    _playBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] CGColor];
    _playBtn.layer.borderWidth = 0.5;
    [self.view addSubview:_playBtn];
    
    [self.view bringSubviewToFront:_playBtn];
    _bPauseVideoStream = NO;
    
    _mp4PlayView = [[GifitPlayView alloc]initWithFrame:self.view.frame];
    _mp4PlayView.hidden = YES;
    [self.view addSubview:_mp4PlayView];
    
    
    size.width =  1280;
    size.height = 720;
    _cameraManager = [[GLiveCameraManager alloc] initWithDelegate:self];
    [_cameraManager setCameraResolutionWidth:size.width height:size.height];
    [_cameraManager switchCamera:YES];
    [_cameraManager startSession];
}

-(void)onPauseCameraVideo
{
    _bPauseVideoStream = !_bPauseVideoStream;
}

-(void)scaleGLRenderView:(UIPinchGestureRecognizer*)gesture
{
    CGFloat scale = gesture.scale;
    
    if (scale > 1.0) {
        if (self.totalScale >MAXSCALE) {
            return;
        }
    }
    
    if(scale < 1.0)
    {
        if(self.totalScale < MINSCALE){
            return;
        }
    }
    
    self.totalScale*= scale;
    
    // 根据手势处理器的缩放比例计算图片缩放后的目标大小
    CGSize targetSize = CGSizeMake(_frameCAEAGLLayer.size.width*scale +10,
                                   _frameCAEAGLLayer.size.height*scale);
    
    _frameCAEAGLLayer.size = targetSize;
    _viewDrawImage.frame = _frameCAEAGLLayer;
}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
//    if (_viewDrawImage == nil) {
//        return;
//    }
    
//    if ([_viewDrawImage.render isMemberOfClass:[GLiveGLRenderRGB class]]) {
//        [self processVideoSampleBufferToRGB1:sampleBuffer];
//    }else {
        [self processVideoSampleBufferToYUV:sampleBuffer];
//    }
}

// 视频格式为：kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange或kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
- (void)processVideoSampleBufferToRGB1:(CMSampleBufferRef)sampleBuffer
{
//    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    //size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
//    //printf("%zud\n", count);
//    
//    //表示开始操作数据
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    
//    int pixelWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
//    int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
//    
//    GLTextureRGB *rgb = [[GLTextureRGB alloc] init];
//    rgb.width = pixelWidth;
//    rgb.height = pixelHeight;
//    
//    // Y数据
//    //size_t y_size = pixelWidth * pixelHeight;
//    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    
//    // UV数据
//    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//    //size_t uv_size = y_size/2;
//    
//    // ARGB = BGRA 大小端问题 转换出来的数据是BGRA
//    uint8_t *bgra = malloc(pixelHeight * pixelWidth * 4);
//    NV12ToARGB(y_frame, pixelWidth, uv_frame, pixelWidth, bgra, pixelWidth * 4, pixelWidth, pixelHeight);
//    
//    rgb.RGBA = bgra;
//    
//    // Unlock
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        OpenGLESView *glView = (OpenGLESView *)self.view;
//        [glView setTexture:rgb];
//        [glView setNeedDraw];
//    });
}

// 视频格式为：kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange或kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
- (void)processVideoSampleBufferToYUV:(CMSampleBufferRef)sampleBuffer
{
    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //表示开始操作数据
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    int pixelWidth = (int) CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
    
    GLTextureYUV *yuv = [[GLTextureYUV alloc] initWithSize:CGSizeMake(pixelWidth, pixelHeight)];
    
    //size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
    //获取CVImageBufferRef中的y数据
    size_t y_size = pixelWidth * pixelHeight;
    //uint8_t *yuv_frame =malloc(y_size);
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    memcpy(yuv.Y, y_frame, y_size);
    //yuv.Y = yuv_frame;
    
    // UV数据
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t uv_size = y_size/2;
    
    //获取CMVImageBufferRef中的u数据
    size_t u_size = y_size/4;
    //uint8_t *u_frame = malloc(u_size);
    uint8_t *u_frame = yuv.U;
    for (int i = 0, j = 0; i < uv_size; i += 2, j++) {
        u_frame[j] = uv_frame[i];
    }
    //yuv.U = u_frame;
    
    //获取CMVImageBufferRef中的v数据
    size_t v_size = y_size/4;
    //uint8_t *v_frame = malloc(v_size);
    uint8_t *v_frame = yuv.V;
    for (int i = 1, j = 0; i < uv_size; i += 2, j++) {
        v_frame[j] = uv_frame[i];
    }
    //yuv.V = v_frame;
    
    // Unlock
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    
//    dispatch_sync([GLiveGLShareInstance shareInstance].cellLayoutQueue , ^{
//
//        if (_bPauseVideoStream) {
//            [_viewDrawImage clearVideoFrame];
//            return;
//        }
//
//        [_viewDrawImage setTexture:yuv];
//        [_viewDrawImage setNeedDraw];
//
////        [_viewDrawImage1 setTexture:yuv];
////        [_viewDrawImage1 setNeedDraw];
//    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{

        [_viewDrawImage setTexture:yuv];
        [_viewDrawImage setNeedDraw];

//        [_viewDrawImage1 setTexture:yuv];
//        [_viewDrawImage1 setNeedDraw];
    });
}

-(void)onPlayLuxuryGift
{
    NSString* path =  [[NSBundle mainBundle] pathForResource:@"huojian_zuoyou.mp4" ofType:nil];
    [_mp4PlayView playFile:path];
    _mp4PlayView.hidden = NO;
}

@end
