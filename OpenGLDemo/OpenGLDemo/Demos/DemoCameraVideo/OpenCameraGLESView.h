#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLRender.h"

@interface OpenCameraGLESView : UIView
@property (nonatomic, strong) GLiveGLRender *render;
@property (nonatomic, assign) uint16_t viewTag;
- (void)setTexture:(GLTexture *)texture;
- (void)setNeedDraw;
- (void)clearVideoFrame;
- (instancetype)initWithFrame:(CGRect)frame withHighResolution:(BOOL)high;
@end
