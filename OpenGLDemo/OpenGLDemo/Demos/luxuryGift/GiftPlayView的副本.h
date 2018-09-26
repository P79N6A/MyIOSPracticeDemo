#import "GLView.h"

@protocol IPLGiftPlayListener <NSObject>

- (void)onVideoSize:(int)width andHeight:(int)height;
- (void)onStart;
- (void)enEnd;
- (void)onPlayAtTime:(uint64_t)presentationTimeUs;
- (void)onError:(int)errorCode;

@end 


@interface GifitPlayView : GLView

@property (weak,nonatomic) id<IPLGiftPlayListener> delegate;

- (id)initWithFrame:(CGRect) frame;

- (BOOL)playFile:(NSString*) filePath;

- (BOOL)playAssetsFile:(NSString*) filePath;

- (void)stopPlay;

@end
