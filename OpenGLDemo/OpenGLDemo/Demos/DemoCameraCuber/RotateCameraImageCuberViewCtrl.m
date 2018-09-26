//
//  RotateCameraImageCuberViewCtrl
//  OpenGLDemo
//
#import "RotateCameraImageCuberViewCtrl.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraCuberGLESView.h"
#import "GLiveCameraManager.h"
#import "GLiveGLShareInstance.h"
//#import "GiftPlayView.h"
#import "libyuv.h"
#import "GLTexture.h"


#define MAXSCALE 2.0 //最大缩放比例
#define MINSCALE 0.5 //最小缩放比例

@interface RotateCameraImageCuberViewCtrl ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    CGRect              _frameCAEAGLLayer;
    CameraCuberGLESView *_viewDrawImage;
    
    CGRect              _frameCAEAGLLayer1;
    //OpenCameraGLESView *_viewDrawImage1;
    
    GLiveCameraManager* _cameraManager;
    dispatch_queue_t    _cellLayoutQueue;
    UIButton*           _playBtn;
    BOOL                _bPauseVideoStream;
    BOOL                _mirror;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic) UIImage *originImage;
@property (nonatomic) UIImageView *originImageView;
@property (nonatomic, assign) CGFloat totalScale;
@property (nonatomic, strong) NSMutableDictionary* test_dic;
@end

@implementation RotateCameraImageCuberViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalScale = 1;
    _frameCAEAGLLayer = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewDrawImage = [[CameraCuberGLESView alloc] initWithFrame:_frameCAEAGLLayer withHighResolution:YES];
    _viewDrawImage.userInteractionEnabled = YES;
    _viewDrawImage.multipleTouchEnabled = YES;
//    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleGLRenderView:)];
//    [_viewDrawImage addGestureRecognizer:gesture];
    [self.view addSubview:_viewDrawImage];

    
    CGSize size;
//    size.width =  640;
//    size.height = 480;

    size.width =  1280;
    size.height = 720;
    
    _test_dic = [[NSMutableDictionary alloc]init];
    [_test_dic setObject:@{@"jsonData":@"erererer",
                           @"time": @([NSDate date].timeIntervalSince1970)
                           } forKey:@"1"];

    [self setupSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![_captureSession isRunning]) {
        [self switchCamera:YES];
        [_captureSession startRunning];
    }
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


- (void)setupSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    
    // 设置换面尺寸
    [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    // 设置输入设备
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            inputCamera = device;
        }
    }
    
    if (!inputCamera) {
        return;
    }
    
    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:&error];
    if ([_captureSession canAddInput:_videoInput])
    {
        [_captureSession addInput:_videoInput];
    }
    
    // 设置输出数据
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
    {
        //因为打开摄像头的时候可能还没拉到后台下发的角色，初始化为默认角色的帧率
        _cameraFps = 20;
        
        
        if(_videoOutput && [_videoOutput respondsToSelector: @selector(connectionWithMediaType:)])
        {
            AVCaptureConnection *connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
            connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            [connection setVideoMirrored:YES];
//            if ((_mirror) == YES && [connection isVideoMirroringSupported])
//            {
//                [connection setVideoMirrored:_mirror];
//            }
            if (connection && [connection respondsToSelector:@selector(isVideoMinFrameDurationSupported)]) {
                if ([connection isVideoMinFrameDurationSupported])
                    connection.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                if ([connection isVideoMaxFrameDurationSupported])
                    connection.videoMaxFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            }
            else
            {
                //videoDataOutput.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                _videoOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            }
        }
        else
        {
            //videoDataOutput.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            _videoOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
        }
    }
    
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    [_captureSession commitConfiguration];
}

- (AVCaptureDevicePosition)cameraPosition
{
#if TARGET_IPHONE_SIMULATOR
#else
    NSArray *inputs = _captureSession.inputs;
    for(AVCaptureDeviceInput *input in inputs)
    {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            return [device position];
        }
    }
#endif
    return AVCaptureDevicePositionUnspecified;
}

+ (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            return device;
        }
    }
    return nil;
}

+ (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

+ (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

+ (BOOL)isFrontCameraExist
{
    return [self frontCamera] != nil;
}



+ (BOOL)isBackCameraExist
{
    return [self backCamera] != nil;
}

- (BOOL)switchCamera:(BOOL)front
{
    
    //GLiveLog("switchCamera:%d", front);
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    _mirror = front;
    
    if (front) {
        if (![[self class]isFrontCameraExist]) {
            //QZLVLOG_ERROR(@"front camera not exist");
            return NO;
        }
        if ([self cameraPosition] == AVCaptureDevicePositionFront) {
            return YES;
        }
    } else {
        if (![[self class]isBackCameraExist]) {
            //QZLVLOG_ERROR(@"back camera not exist");
            return NO;
        }
        if ([self cameraPosition] == AVCaptureDevicePositionBack) {
            return YES;
        }
    }
    
    AVCaptureDeviceInput *inputToRemove = nil;
    NSArray *inputs = _captureSession.inputs;
    for(AVCaptureDeviceInput *input in inputs)
    {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            inputToRemove = input;
            break;
        }
    }
    
    AVCaptureDevice *newCamera = nil;
    if (front)
    {
        newCamera = [[self class] cameraWithPosition:AVCaptureDevicePositionFront];
    }
    else
    {
        newCamera = [[self class] cameraWithPosition:AVCaptureDevicePositionBack];
    }
    if (!newCamera) {
        //QZLVLOG_ERROR_K(@"can't get camera device");
        return NO;
    }
    
    //单判断canSetSessionPreset还不够，还需要判断设备是否支持preset
    if (![newCamera supportsAVCaptureSessionPreset:_captureSession.sessionPreset]) {
        //QZLVLOG_INFO(@"device not support preset[%@], change to AVCaptureSessionPresetMedium",_session.sessionPreset);
        _captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    }
    
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (!newInput) {
        //QZLVLOG_ERROR_K(@"deviceInputWithDevice return nil");
        return NO;
    }
    
    [_captureSession beginConfiguration];
    if (inputToRemove) {
        [_captureSession removeInput:inputToRemove];
    }
    [_captureSession addInput:newInput];
    AVCaptureConnection* connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    if ([connection isVideoMirroringSupported])
    {
        [connection setVideoMirrored:_mirror];
    }
    
    [_captureSession commitConfiguration];
    
    return YES;
#endif
}


#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    NSDictionary * dic = [_test_dic objectForKey:@"1"];
    if (dic) {
        double time = ((NSNumber*)dic[@"time"]).doubleValue;
        // 12小时时效性
        if (([NSDate date].timeIntervalSince1970 - time) < 12 * 60 * 60) {
            NSData * jsonData = dic[@"jsonData"];
        }
    }
//    if (_viewDrawImage == nil) {
//        return;
//    }
    
//    if ([_viewDrawImage.render isMemberOfClass:[GLiveGLRenderRGB class]]) {
//        [self processVideoSampleBufferToRGB1:sampleBuffer];
//    }else {
//        [self processVideoSampleBufferToYUV:sampleBuffer];
//    }
    
    [self processVideoSampleBufferToRGB:sampleBuffer];
}

//指定缩放大小
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

// 视频格式为：kCVPixelFormatType_32BGRA
- (void)processVideoSampleBufferToRGB:(CMSampleBufferRef)sampleBuffer
{
    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    //CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //UIImage* image = [self pixelBufferToImage:sampleBuffer];

    
    CVImageBufferRef imageBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CGSize dstSize = CGSizeMake(256, 256);
    UIImage* dstImage = [self scaleImage:image toSize:dstSize];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_viewDrawImage setImageTexture:dstImage];
    });

}

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)

+(UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBufffer{
    CVPixelBufferLockBaseAddress(pixelBufffer, 0);// 锁定pixel buffer的基地址
    void * baseAddress = CVPixelBufferGetBaseAddress(pixelBufffer);// 得到pixel buffer的基地址
    size_t width = CVPixelBufferGetWidth(pixelBufffer);
    size_t height = CVPixelBufferGetHeight(pixelBufffer);
    size_t bufferSize = CVPixelBufferGetDataSize(pixelBufffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBufffer);// 得到pixel buffer的行字节数
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();// 创建一个依赖于设备的RGB颜色空间
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       kBitsPerComponent,
                                       kBitsPerPixel,
                                       bytesPerRow,
                                       rgbColorSpace,
                                       kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault,
                                       provider,
                                       NULL,
                                       true,
                                       kCGRenderingIntentDefault);//这个是建立一个CGImageRef对象的函数
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);  //类似这些CG...Ref 在使用完以后都是需要release的，不然内存会有问题
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);//1代表图片是否压缩
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(pixelBufffer, 0);   // 解锁pixel buffer
    
    return image;
}

#pragma mark -
#pragma mark - 缩放处理
//缩放倍数
- (UIImage *)scaleImage:(UIImage *)image withScale:(float)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


// 视频格式为：kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange或kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
- (void)processVideoSampleBufferToRGB1:(CMSampleBufferRef)sampleBuffer
{
//    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
    //printf("%zud\n", count);

    //表示开始操作数据
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    int pixelWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);

    GLTextureRGB *rgb = [[GLTextureRGB alloc] init];
    rgb.width = pixelWidth;
    rgb.height = pixelHeight;

    // Y数据
    //size_t y_size = pixelWidth * pixelHeight;
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);

    // UV数据
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    //size_t uv_size = y_size/2;

    // ARGB = BGRA 大小端问题 转换出来的数据是BGRA
    uint8_t *bgra = malloc(pixelHeight * pixelWidth * 4);
    NV12ToARGB(y_frame, pixelWidth, uv_frame, pixelWidth, bgra, pixelWidth * 4, pixelWidth, pixelHeight);

    rgb.RGBA = bgra;

    // Unlock
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    dispatch_sync(dispatch_get_main_queue(), ^{
        //[_viewDrawImage setTexture:rgb];
//        OpenGLESView *glView = (OpenGLESView *)self.view;
//        [glView setTexture:rgb];
//        [glView setNeedDraw];
    });
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
    
    dispatch_sync(dispatch_get_main_queue(), ^{

//        [_viewDrawImage setTexture:yuv];
//        [_viewDrawImage setNeedDraw];
//
//        [_viewDrawImage1 setTexture:yuv];
//        [_viewDrawImage1 setNeedDraw];
    });
}


@end
