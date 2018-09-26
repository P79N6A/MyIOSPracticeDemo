//
//  GiftPlayView.m
//  giftDemo
//
//  Created by 魏亮 on 2017/3/28.
//  Copyright © 2017年 魏亮. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "GiftPlayView.h"
#import "GPWeakSelectorTarget.h"
#import "GLiveGLShareInstance.h"


NSString * const kGPStatusKey = @"status";

static void *GPAVPlayerPlaybackViewControllerStatusObservationContext = &GPAVPlayerPlaybackViewControllerStatusObservationContext;


#define displaytime 0.03

@interface GifitPlayView()
{
    AVPlayerItemVideoOutput     *_videoOutput;
    AVPlayer                    *_player;
    AVPlayerItem                *_playerItem;
    CADisplayLink               *_displayLink;
    BOOL                        _sendSize;
    CVPixelBufferRef            _pixelBuffeRef;
}
@end

@implementation GifitPlayView



- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForeground)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackground)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioInterruption:)  name:AVAudioSessionInterruptionNotification object:nil];
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlay];
}


- (BOOL)playFile:(NSString*) filePath
{
    if(!filePath){
        return NO;
    }
    
    [self stopPlay];
    NSDictionary *pixelBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    _videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixelBuffAttributes];
    
    //NSString *str = @"http://w3school.com.cn/i/movie.mp4";
    //    if([filePath UTF8String][0] == '/')
    NSString* str = [NSString stringWithFormat:@"file://%@",filePath ];
    
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:str]];
    [_playerItem addOutput:_videoOutput];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    [_videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:displaytime];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_playerItem];
    
    [_playerItem addObserver:self
                  forKeyPath:kGPStatusKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:GPAVPlayerPlaybackViewControllerStatusObservationContext];
    _sendSize = false;
    
    [self setupDisplayLink];
    
    return YES;
}

- (BOOL)playAssetsFile:(NSString*) filePath
{
    return NO;
}


- (void)setupDisplayLink {
    if (_displayLink == nil) {
        GPWeakSelectorTarget *target = [[GPWeakSelectorTarget alloc] initWithTarget:self targetSelector:@selector(displayVideo)];
        _displayLink = [CADisplayLink displayLinkWithTarget:target selector:target.handleSelector];
        _displayLink.frameInterval = 2;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
}

- (void)unsetupDisplayLink {
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    [self stopPlay];
//    if(_delegate && [_delegate respondsToSelector:@selector(enEnd)]){
//        [_delegate enEnd];
//    }
}

- (void)observeValueForKeyPath:(NSString*)path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    if (context == GPAVPlayerPlaybackViewControllerStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
                
                break;
            case AVPlayerStatusReadyToPlay:
                [_player play];
//                if(_delegate && [_delegate respondsToSelector:@selector(onStart)]){
//                    [_delegate onStart];
//                }
                break;
                
            case AVPlayerStatusFailed: {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
//                if(_delegate && [_delegate respondsToSelector:@selector(onError:)]){
//                    [_delegate onError:(int)playerItem.error.code];
//                }
                
                [self stopPlay];
                break;
            }
        }
    }
}

- (void)displayVideo
{
    if([_videoOutput hasNewPixelBufferForItemTime:[_player.currentItem currentTime]]){
        CVPixelBufferRef pixelBuffer = [_videoOutput copyPixelBufferForItemTime:[_player.currentItem currentTime] itemTimeForDisplay:nil];
        if(pixelBuffer){
            //表示开始操作数据
//            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//
//            int pixelWidth = (int) CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
//            int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
//            OSType type= CVPixelBufferGetPixelFormatType(pixelBuffer);
//
//            GLTextureYUV *yuv = [[GLTextureYUV alloc] initWithSize:CGSizeMake(pixelWidth, pixelHeight)];
//
//            //size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
//            //获取CVImageBufferRef中的y数据
//            size_t y_size = pixelWidth * pixelHeight;
//            //uint8_t *yuv_frame =malloc(y_size);
//            uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//            memcpy(yuv.Y, y_frame, y_size);
//            //yuv.Y = yuv_frame;
//
//            // UV数据
//            uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//            size_t uv_size = y_size/2;
//
//            //获取CMVImageBufferRef中的u数据
//            size_t u_size = y_size/4;
//            //uint8_t *u_frame = malloc(u_size);
//            uint8_t *u_frame = yuv.U;
//            for (int i = 0, j = 0; i < uv_size; i += 2, j++) {
//                u_frame[j] = uv_frame[i];
//            }
//            //yuv.U = u_frame;
//
//            //获取CMVImageBufferRef中的v数据
//            size_t v_size = y_size/4;
//            //uint8_t *v_frame = malloc(v_size);
//            uint8_t *v_frame = yuv.V;
//            for (int i = 1, j = 0; i < uv_size; i += 2, j++) {
//                v_frame[j] = uv_frame[i];
//            }
//            //yuv.V = v_frame;
//
//            // Unlock
//            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//            [self setTexture:yuv];
            
             //[self setMp4VideoFrame:pixelBuffer];
            [self display:pixelBuffer];
            
//            dispatch_sync([GLiveGLShareInstance shareInstance].cellLayoutQueue , ^{
//                [self setMp4VideoFrame:pixelBufferef];
//            });
            //[self display:pixelBuffer];
            self.hidden = NO;
            

        }
    }
    
    
}

- (void)stopPlay
{
    
    @try {
        if(_playerItem){
            [_playerItem removeObserver:self forKeyPath:kGPStatusKey];
            [_playerItem removeOutput:_videoOutput];
            _player=nil;
            _videoOutput = nil;
            _playerItem = nil;
            [self unsetupDisplayLink];
        }
    } @catch(id anException) {
        //do nothing
    }
    self.hidden = YES;
}


-(void)onAudioInterruption:(NSNotification*)notify
{
    NSDictionary* dic = notify.userInfo;
    if (dic)
    {
        int reason = [[dic valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
        switch (reason) {
            case AVAudioSessionInterruptionTypeBegan: {
                break;
            }
            case AVAudioSessionInterruptionTypeEnded:{
                if(_player)
                    [_player play];
                break;
            }
        }
    }
}

-(void)enterForeground
{
    if(_player)
        [_player play];
}

-(void)enterBackground
{
    
}

- (void)routeChange:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            if(_player)
                [_player play];
        }
        
    }
}
@end

