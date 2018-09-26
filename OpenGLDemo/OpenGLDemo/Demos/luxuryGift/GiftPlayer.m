//
//  GiftPlayer.m
//  giftDemo
//
//  Created by weiliang on 2017/9/22.
//  Copyright © 2017年 魏亮. All rights reserved.
//

#import "GiftPlayer.h"
//#include "libavformat/avformat.h"
//#include "libavcodec/avcodec.h"
//#include "libavutil/avutil.h"
//#include "libavutil/frame.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <VideoToolbox/VideoToolbox.h>
//#import "h264_sps_parser.h"
#import <AVFoundation/AVFoundation.h>
@interface GiftPlayer()
{
     AVFormatContext *_ic;
    int             _width;
    int             _height;
    int             _videoStreamIndex;
    dispatch_queue_t _decoderQueue;
    int _minqueueSize;
    int _maxqueueSize;
    CMVideoFormatDescriptionRef _videoFormatDescription;
    VTDecompressionSessionRef _decompressionRef;
    NSLock*   _decompression_lock;
    NSString* _filePath;
    NSData *spsData;
    NSData *ppsData;
    BOOL _isRequestIFrame;
    BOOL _stopFlag;
    BOOL _isFileEnd;
    BOOL _pause;
    CFTimeInterval _lastPlayTime;//单独播放视频的时候使用
    CFTimeInterval _firstPlayTime;
    CFTimeInterval _firstframeTime;
    CFTimeInterval _curPlayTime;
}
@property (nonatomic, strong) NSMutableArray *outputFrames;
@property (nonatomic, strong) NSMutableArray *presentationTimes;
@end

@implementation GiftPlayer
-(instancetype)init{
    if(self = [super init]){
        self.outputFrames = [NSMutableArray array];
        self.presentationTimes = [NSMutableArray array];
        _decoderQueue = dispatch_queue_create("GiftPlayerDecoderQueue", NULL);
        _minqueueSize = 0;
        _maxqueueSize = 15;
        _decompression_lock = [[NSLock alloc] init];
        _isRequestIFrame = YES;
    }
    return self;
}

- (void)dealloc{
    [self tearDownDecompressionSession];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_videoFormatDescription) {
        CFRelease(_videoFormatDescription);
    }
    _decompression_lock = nil;
}

- (BOOL)playFile:(NSString*) filePath
{
    _filePath = [filePath copy];
    _stopFlag = NO;
    _lastPlayTime = 0;
    _firstPlayTime = 0;
    _firstframeTime = 0;
    _isFileEnd = NO;
    _pause = NO;
    _curPlayTime = 0;
    dispatch_async(_decoderQueue, ^{
        [self decoderInThread];
    });
    return NO;
}

- (void)stop
{
    _stopFlag = YES;
    
}

- (BOOL)closeFile
{
    if (_ic) {
        avformat_close_input(&_ic);
        _ic = nil;
    }

    return YES;
}


- (BOOL)decode:(uint8_t *)bytes length:(uint32_t)length timestamp:(int64_t)timestamp isIFrame:(BOOL)isIFrame {
    
    @autoreleasepool {
        CMBlockBufferRef blockBuffer = NULL;
        
        OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                              bytes, length,
                                                              kCFAllocatorNull,
                                                              NULL, 0, length,
                                                              0, &blockBuffer);
        if (status != kCMBlockBufferNoErr) {
            return NO;
        }
        
        CMSampleBufferRef sampleBuffer = NULL;
        
        const size_t sampleSizeArray[] = { length };
        CMSampleTimingInfo timingInfo = {0};
        timingInfo.presentationTimeStamp = CMTimeMake(timestamp, 1000);
        
        status = CMSampleBufferCreateReady(kCFAllocatorDefault, blockBuffer, _videoFormatDescription , 1, 1, &timingInfo, 1, sampleSizeArray, &sampleBuffer);
        
        CFRelease(blockBuffer);
        
        if (status != kCMBlockBufferNoErr || !sampleBuffer) {
            return NO;
        }
        
        VTDecodeFrameFlags flags = kVTDecodeFrame_EnableAsynchronousDecompression;
        VTDecodeInfoFlags flagOut = 0;
        OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decompressionRef, sampleBuffer, flags, NULL, &flagOut);
        CFRelease(sampleBuffer);
        
        if (decodeStatus == kVTInvalidSessionErr) {
            //QZLiveLogEvent("Invalid session, reset decoder session");
        } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
           // QZLiveLogEvent("Decode failed status = %d(Bad data)", (int)decodeStatus);
        } else if(decodeStatus != noErr) {
           // QZLiveLogEvent("Decode failed status=%d", (int)decodeStatus);
        }
        
        if (decodeStatus != noErr) {
           // [self.stastics recordVideoDecodeFailed:decodeStatus];
        }
        
        if (decodeStatus == kVTInvalidSessionErr)
            return YES;
        else
            return NO;
    }
}

static void H264DecompressionOutputCallback(
                                            void *decompressionOutputRefCon,
                                            void *sourceFrameRefCon,
                                            OSStatus status,
                                            VTDecodeInfoFlags infoFlags,
                                            CVImageBufferRef imageBuffer,
                                            CMTime presentationTimeStamp,
                                            CMTime presentationDuration) {
    
    if (status != noErr) {
        return;
    }
    
    if (imageBuffer == NULL) {
        return;
    }
    

    
    __weak __block GiftPlayer *weakSelf = (__bridge GiftPlayer *)decompressionOutputRefCon;
    
    
    if(presentationTimeStamp.value == 0XFFFFFFFFFFFFFFFF)//表示这一帧不需要显示
        return;
    
    NSNumber *framePTS = nil;
    if (CMTIME_IS_VALID(presentationTimeStamp)) {
        framePTS = [NSNumber numberWithDouble:CMTimeGetSeconds(presentationTimeStamp)];
    } else {
        
    }
    
    if (framePTS) { // find the correct position for this frame in the output frames array
        @synchronized(decompressionOutputRefCon) {
            id imageBufferObject = (__bridge id)imageBuffer;
            
            BOOL shouldStop = NO;
            NSInteger insertionIndex = [weakSelf.presentationTimes count] - 1;
            
            while (insertionIndex >= 0 && shouldStop == NO) {
                NSNumber *aNumber = weakSelf.presentationTimes[insertionIndex];
                if ([aNumber doubleValue] <= [framePTS doubleValue]) {
                    shouldStop = YES;
                    break;
                }
                
                insertionIndex--;
            }
            
            if (insertionIndex + 1 == [weakSelf.presentationTimes count]) {
                [weakSelf.presentationTimes addObject:framePTS];
                [weakSelf.outputFrames addObject:imageBufferObject];
            } else {
                [weakSelf.presentationTimes insertObject:framePTS atIndex:insertionIndex + 1];
                [weakSelf.outputFrames insertObject:imageBufferObject atIndex:insertionIndex + 1];
            }
        }
    }
}

- (BOOL)resetDecompressionSession {
    _isRequestIFrame = YES;
    [self tearDownDecompressionSession];
    [_decompression_lock lock];
    BOOL b = [self setupDecompressionSession];
    [_decompression_lock unlock];
    return b;
    
}

- (void)tearDownDecompressionSession {
    [_decompression_lock lock];
    if (_decompressionRef) {
        VTDecompressionSessionWaitForAsynchronousFrames(_decompressionRef);
        VTDecompressionSessionInvalidate(_decompressionRef);
        CFRelease(_decompressionRef);
        _decompressionRef = NULL;
    }
    [_decompression_lock unlock];
}

- (BOOL)configWithSPS:(uint8_t*)data andSize:(int)size
{
    if(size < 10)
     return  NO;
    
    int startCodeSPSIndex = 7;
    int spsLength = data[7];
    int startCodePPSIndex = startCodeSPSIndex+spsLength+3;
    int ppsLength = data[startCodePPSIndex];
    int nalu_type;
    nalu_type = ((uint8_t) data[startCodeSPSIndex + 1] & 0x1F);
    if (nalu_type == 7) {
        spsData = [[NSData alloc]initWithBytes:&(data[startCodeSPSIndex + 1]) length: spsLength];
    }
    nalu_type = ((uint8_t) data[startCodePPSIndex + 1] & 0x1F);
    if (nalu_type == 8) {
        ppsData = [[NSData alloc]initWithBytes:&(data[startCodePPSIndex + 1]) length: ppsLength];
    }
    
    uint8_t *parameterSetPointers[2] = {(uint8_t *)spsData.bytes, (uint8_t *)ppsData.bytes};
    size_t parameterSetSizes[2] = {spsData.length, ppsData.length};
    int max_ref_frames;
    int sps_level;
    int sps_profile;
    validate_avcC_spc(spsData.bytes, (uint32_t)spsData.length, &max_ref_frames, &sps_level, &sps_profile);
    _minqueueSize = max_ref_frames;
    _maxqueueSize = _minqueueSize + 5;
    OSStatus  status = CMVideoFormatDescriptionCreateFromH264ParameterSets(
                                                                           kCFAllocatorDefault,
                                                                           2,
                                                                           (const uint8_t *const*)parameterSetPointers,
                                                                           parameterSetSizes,
                                                                           4,
                                                                           &_videoFormatDescription
                                                                           );
    
    if (status == noErr) {
        return [self resetDecompressionSession];
    }
    
    return NO;
}

- (BOOL)setupDecompressionSession {

    if (!_videoFormatDescription) {
        return NO;
    }
    
    NSDictionary *attributes = @{
                                 (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange),
                                 (id)kCVPixelBufferOpenGLCompatibilityKey : @(YES)
                                 };
    
    VTDecompressionOutputCallbackRecord callBackRecord;
    callBackRecord.decompressionOutputCallback = H264DecompressionOutputCallback;
    callBackRecord.decompressionOutputRefCon = (__bridge void *)(self);
    
    OSStatus status = VTDecompressionSessionCreate(
                                                   kCFAllocatorDefault,
                                                   _videoFormatDescription,
                                                   NULL,
                                                   (__bridge CFDictionaryRef)(attributes),
                                                   &callBackRecord,
                                                   &_decompressionRef);
    
    VTSessionSetProperty(_decompressionRef, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)(@1));
    VTSessionSetProperty(_decompressionRef, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);
    
    if (status != noErr) {
        _decompressionRef = NULL;
        return NO;
    }
    
    return YES;
}

- (CFTimeInterval)getRealTime{
    CFTimeInterval realTime = CACurrentMediaTime() - _firstPlayTime;
    return realTime;
}

- (uint64_t)getCurPlayTime
{
    return _curPlayTime*1000000;
}

- (CVPixelBufferRef)getImage
{
    if(_pause){
        return nil;
    }
    @synchronized (self) {
        
        if ([self.outputFrames count] <= _minqueueSize && !_isFileEnd) {
            return nil;
        }
        if(self.outputFrames.count == 0)
            return nil;
    
        NSNumber *framePTS = nil;
        id imageBufferObject = nil;
    
        framePTS = [self.presentationTimes firstObject];
        imageBufferObject = [self.outputFrames firstObject];
        CFTimeInterval nowt = CACurrentMediaTime();
        if(_firstPlayTime <= 0.1){
            _firstPlayTime = nowt;
            _firstframeTime = [framePTS doubleValue];
        }
        int diff = [framePTS doubleValue] - _firstframeTime - [self getRealTime];
        if(_lastPlayTime != 0 && diff > 0 )
        {
            return nil;
        }

        _lastPlayTime = nowt;
        if (imageBufferObject) {
            [self.outputFrames removeObjectAtIndex:0];
        }
    
        if (framePTS) {
            [self.presentationTimes removeObjectAtIndex:0];
        }
        _curPlayTime =  [framePTS doubleValue];
        CVImageBufferRef imageBuffer = (__bridge CVImageBufferRef)imageBufferObject;
        CFRetain(imageBuffer);
        return imageBuffer;
    }
}

- (void)pause
{
    _pause = YES;
    
}

- (void)resume
{
    [self resetDecompressionSession];
    _firstframeTime = _curPlayTime;
    _firstPlayTime = CACurrentMediaTime();
    _pause = NO;
}

- (void)decoderInThread
{
    if (_ic){
        [self closeFile];
    }
    uint8_t*data = NULL;
    int datasize = 0;
    int error = 0;
    
    av_register_all();
    if(avformat_open_input(&_ic, [_filePath UTF8String], nil, nil) < 0){
        error = GiftPlayerErrorOpenFile;
        goto fail;
    }

    if(avformat_find_stream_info(_ic, nil) < 0){
        error = GiftPlayerErrorMeidaInfo;
        goto fail;
    }
    _videoStreamIndex  = av_find_best_stream(_ic,  AVMEDIA_TYPE_VIDEO, -1, -1, nil, 0);
    
    if (_videoStreamIndex < 0){
        error = GiftPlayerErrorMeidaInfo;
        goto fail;
    }
    
    if(![self configWithSPS:_ic->streams[_videoStreamIndex]->codec->extradata andSize:_ic->streams[_videoStreamIndex]->codec->extradata_size]){
        error = GiftPlayerErrorDecode;
        goto fail;
    }

    while (!_stopFlag) {

        if(self.outputFrames.count == 0 && _isFileEnd){
            dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate && [_delegate respondsToSelector:@selector(onGiftPlayEnd)]){
                [_delegate onGiftPlayEnd];
            }
            });
            break;
        }
        
        if(self.outputFrames.count > _maxqueueSize || _isFileEnd || _pause){
            usleep(10 * 1000);
            continue;
        }
        AVPacket pkt;
        av_init_packet(&pkt);
        int ret =  av_read_frame(_ic, &pkt);
        if (ret < 0) {
            _isFileEnd = YES;
            continue;
        }
        if(pkt.stream_index == _videoStreamIndex){
            double pts = pkt.pts*1.0*av_q2d(_ic->streams[_videoStreamIndex]->time_base)*1000;
            [self decode:pkt.data length:pkt.size timestamp:pts isIFrame:pkt.flags&AV_PKT_FLAG_KEY];
        }
        av_free_packet(&pkt);
        usleep(10 * 1000);
    }

    fail:
        if (_ic) {
            avformat_close_input(&_ic);
            _ic = nil;
        }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error &&_delegate && [_delegate respondsToSelector:@selector(onGiftPlayError:)]){
            [_delegate onGiftPlayError:error];
        }
    });
    @synchronized (self) {
        [self.outputFrames removeAllObjects];
        [self.presentationTimes removeAllObjects];
    }
}
@end
