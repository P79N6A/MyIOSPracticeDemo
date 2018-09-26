//
//  GiftPlayer.h
//  giftDemo
//
//  Created by weiliang on 2017/9/22.
//  Copyright © 2017年 魏亮. All rights reserved.
//

#ifndef GiftPlayer_h
#define GiftPlayer_h
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

typedef enum {
    GiftPlayerErrorOpenFile = 2001,
    GiftPlayerErrorMeidaInfo,
    GiftPlayerErrorDecode
}GiftPlayerErrorCode;

@protocol GiftPlayerDelegate <NSObject>
- (void)onGiftPlayEnd;
- (void)onGiftPlayError:(int)errorCode;
@end

@interface GiftPlayer:NSObject
@property (weak,nonatomic) id<GiftPlayerDelegate> delegate;

- (BOOL)playFile:(NSString*) filePath;

- (CVPixelBufferRef)getImage;

- (uint64_t)getCurPlayTime;

- (void)pause;

- (void)resume;

- (void)stop;

@end
#endif /* GiftPlayer_h */
