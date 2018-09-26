#include <new>
#import "GLiveCameraManager.h"
#import "UIKit/UIDevice.h"

@interface GLiveCameraManager ()
{
#if TARGET_IPHONE_SIMULATOR
#else
    __strong AVCaptureSession          *_session;
    BOOL                                _mirror;
    AVCaptureVideoDataOutput*           _videoDataOutput;
#endif
}
@property (nonatomic, weak) id<AVCaptureVideoDataOutputSampleBufferDelegate>    delegate;
@end

@implementation GLiveCameraManager

+ (BOOL)isEnableLED:(AVCaptureDevicePosition)cameraPosition
{
    AVCaptureDevice *device = [self cameraWithPosition:cameraPosition];
    return [device hasTorch];
}

+ (BOOL)isLEDOn:(AVCaptureDevicePosition)cameraPosition
{
    AVCaptureDevice *device = [self cameraWithPosition:cameraPosition];
    if (![device hasTorch]) {
        return NO;
    }
    if (device.torchMode == AVCaptureTorchModeOn) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)turnLED:(BOOL)on cameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    AVCaptureDevice *device = [self cameraWithPosition:cameraPosition];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        if (on) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
        return YES;
    }
    return NO;
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

+ (GLiveCameraAvailableState)cameraAvailableState {
    if ([GLiveCameraManager isFrontCameraExist] &&
        [GLiveCameraManager isBackCameraExist]) {
        return GLiveCameraBothAvailable;
    }
    else if ([GLiveCameraManager isFrontCameraExist]||
             [GLiveCameraManager isBackCameraExist]) {
        return GLiveCameraOneAvailable;
    }
    
    return GLiveCameraNonAvailable;
}

- (instancetype)initWithDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate {
    if (self = [super init]) {
#if TARGET_IPHONE_SIMULATOR
#else
        _mirror = YES;
        _delegate = delegate;
        _session = [AVCaptureSession new];
        //因为打开摄像头的时候可能还没拉到后台下发的角色，初始化为默认角色的分辨率
        if ([_session canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            _session.sessionPreset = AVCaptureSessionPresetiFrame960x540;
        } else {
            //QZLVLOG_INFO(@"session not support AVCaptureSessionPresetiFrame960x540");
            _session.sessionPreset = AVCaptureSessionPresetMedium;
        }

        
        dispatch_queue_t videoDataQueue = dispatch_queue_create("glivevideodataqueue", NULL);
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        //色彩设置fullrange，颜色更丰富
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        //通过AVCaptureVideoDataOutput设置帧率，与AVSDK的内部实现对齐

        if([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
        {
            //因为打开摄像头的时候可能还没拉到后台下发的角色，初始化为默认角色的帧率
            _cameraFps = 15;
            

            if(_videoDataOutput && [_videoDataOutput respondsToSelector: @selector(connectionWithMediaType:)])
            {
                AVCaptureConnection *connection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
                connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                if ((_mirror) == YES && [connection isVideoMirroringSupported])
                {
                    [connection setVideoMirrored:_mirror];
                }
                if (connection && [connection respondsToSelector:@selector(isVideoMinFrameDurationSupported)]) {
                    if ([connection isVideoMinFrameDurationSupported])
                        connection.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                    if ([connection isVideoMaxFrameDurationSupported])
                        connection.videoMaxFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                }
                else
                {
                    //videoDataOutput.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                    _videoDataOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                }
            }
            else
            {
                //videoDataOutput.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
                _videoDataOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            }
        }
        
        [_videoDataOutput setSampleBufferDelegate:_delegate queue:videoDataQueue];
        if ([_session canAddOutput:_videoDataOutput]) {
            [_session addOutput:_videoDataOutput];
        }
#endif
    }
    return self;
}

- (AVCaptureDevicePosition)cameraPosition
{
#if TARGET_IPHONE_SIMULATOR
#else
    NSArray *inputs = _session.inputs;
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
    NSArray *inputs = _session.inputs;
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
    if (![newCamera supportsAVCaptureSessionPreset:_session.sessionPreset]) {
        //QZLVLOG_INFO(@"device not support preset[%@], change to AVCaptureSessionPresetMedium",_session.sessionPreset);
        _session.sessionPreset = AVCaptureSessionPresetMedium;
    }
    
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (!newInput) {
        //QZLVLOG_ERROR_K(@"deviceInputWithDevice return nil");
        return NO;
    }
    
    [_session beginConfiguration];
    if (inputToRemove) {
        [_session removeInput:inputToRemove];
    }
    [_session addInput:newInput];
    AVCaptureConnection* connection = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    if ([connection isVideoMirroringSupported])
    {
        [connection setVideoMirrored:_mirror];
    }
    
    [_session commitConfiguration];
    
    return YES;
#endif
}

- (void)setCameraFps:(NSInteger)cameraFps
{
    //GLiveLog("setCameraFps:%ld", (long)cameraFps);
#if TARGET_IPHONE_SIMULATOR
    //do nothing
#else
    //QZLVLOG_INFO(@"%@, cameraFps[%zd]", NSStringFromSelector(_cmd), cameraFps);
    if (cameraFps <= 0) {
        return;
    }
    if (cameraFps == _cameraFps) {
        return;
    }
    _cameraFps = cameraFps;
    
    //通过AVCaptureVideoDataOutput设置帧率，与AVSDK的内部实现对齐
    AVCaptureVideoDataOutput *videoOutput;
    for (AVCaptureOutput *output in _session.outputs) {
        if ([output isMemberOfClass:[AVCaptureVideoDataOutput class]]) {
            videoOutput = (AVCaptureVideoDataOutput*)output;
        }
    }
    
    if (videoOutput && [videoOutput respondsToSelector:@selector(connectionWithMediaType:)]) {
        AVCaptureConnection *conn = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if (conn && [conn respondsToSelector:@selector(isVideoMinFrameDurationSupported)]) {
            if ([conn isVideoMinFrameDurationSupported])
                conn.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            if ([conn isVideoMaxFrameDurationSupported])
                conn.videoMaxFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
        }
        else
        {
            //videoOutput.videoMinFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
            videoOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
        }
    }
    else
    {
        //videoOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
        videoOutput.minFrameDuration = CMTimeMake(1,(int32_t)self.cameraFps);
    }
#endif
}

- (BOOL)setCameraResolutionWidth:(NSInteger)width height:(NSInteger)height
{
    //GLiveLog("setCameraResolutionWidth:width=%ld, height=%ld", (long)width, (long)height);
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    //QZLVLOG_INFO(@"%@, width[%zd], height[%zd]", NSStringFromSelector(_cmd), width, height);
    NSString *preset = nil;
    if(width == 352) {
        preset = AVCaptureSessionPreset352x288;
    }else if (width == 640) {
        preset = AVCaptureSessionPreset640x480;
    } else if (width == 960) {
        preset = AVCaptureSessionPresetiFrame960x540;
    } else if (width == 1280) {
        preset = AVCaptureSessionPreset1280x720;
    }
    if ([[_session sessionPreset] isEqualToString:preset]) {
        return YES;
    }
    if (preset) {
        if (![_session canSetSessionPreset:preset]) {
            //GLiveLog("canSetSessionPreset return NO, preset[%@]", preset);
            preset = AVCaptureSessionPresetMedium;
        }
        
        //单判断canSetSessionPreset还不够，还需要判断设备是否支持preset
        if ([self cameraPosition] != AVCaptureDevicePositionUnspecified) {
            AVCaptureDevice *device = [[self class] cameraWithPosition:[self cameraPosition]];
            if (device && ![device supportsAVCaptureSessionPreset:preset]) {
                //QLive
                //QZLVLOG_INFO(@"camera position[zd] not support preset[%@]", [self cameraPosition], preset);
                preset = AVCaptureSessionPresetMedium;
            }
        }
        
        [_session beginConfiguration];
        [_session setSessionPreset:preset];
        [_session commitConfiguration];
        //GLiveLog("setSessionPreset:[%@]", preset);
        return YES;
    } else {
        //GLiveLog("resolution illegal: width[%zd], height[%zd]", width, height);
        return NO;
    }
#endif
}

- (BOOL)startSession
{
    //GLiveLog("startSession");
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    if (_session.running) {
        //QZLVLOG_INFO(@"%@, preview is started!!!", NSStringFromSelector(_cmd));
        return YES;
    }
    
    if ([self cameraPosition] == AVCaptureDevicePositionUnspecified) {
        //QZLVLOG_ERROR(@"%@, AVCaptureDevicePositionUnspecified", NSStringFromSelector(_cmd));
        return NO;
    }
    
    [_session startRunning];
    return YES;
#endif
}

- (void)stopSession
{
    //GLiveLog_MyFunc;
#if TARGET_IPHONE_SIMULATOR
#else
    
    if (!_session || !_session.running) {
        //GLiveLog_Info("%s, session is stopped!!!", NSStringFromSelector(_cmd));
        return;
    }
    
    [_session stopRunning];
#endif
}

- (BOOL)focusAtPoint:(CGPoint)point {
    AVCaptureDevicePosition position = [self cameraPosition];
    if (AVCaptureDevicePositionUnspecified == position) {
        //GLiveLog_Info("手动聚焦时，无法确定是前置摄像头还是后置摄像头");
        return NO;
    }
    
    BOOL isFront = position == AVCaptureDevicePositionFront ? YES : NO;
    
    
    AVCaptureDevice *device = isFront ? [GLiveCameraManager frontCamera] : [GLiveCameraManager backCamera];
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            //[device setFocusPointOfInterest:point];
        }
        
        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [device setExposurePointOfInterest:point];
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            //[device setExposurePointOfInterest:point];
        }
        
        [device unlockForConfiguration];
    }
    
    if (error) {
        return NO;
    }
    return YES;
}

@end
