#import "OpenCameraGLESView.h"
#import <OpenGLES/ES2/gl.h>
#import "GLiveGLUtil.h"
#import "GLiveAVEnum.h"
#import "GLiveGLShareInstance.h"

@interface OpenCameraGLESView ()
{
    CAEAGLLayer     *_eaglLayer;
//    EAGLContext     *_context;
    GLuint          _colorRenderBuffer;
    GLuint          _frameBuffer;
    CGRect          _rcViewport;
    CGSize          _videoFrameSize;
    CGSize          _viewSize;
    GLiveGLRender*  _render;
    CGFloat       _yRotateAngle;
    CGFloat       _xRotateAngle;
    CGFloat       _zRotateAngle;
    //BOOL          _glHighResolution;
    CGFloat          _contentScale;
}
@end

@implementation OpenCameraGLESView

+ (Class)layerClass
{
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame withHighResolution:(BOOL)high
{
    if (self = [super initWithFrame:frame]) {
        if (high){
            _contentScale = [UIScreen mainScreen].scale;
        }else{
            _contentScale = 1;
        }
        _rcViewport = CGRectMake(0,0, frame.size.width*_contentScale, frame.size.height*_contentScale);
        _viewSize = frame.size;
        _videoFrameSize = CGSizeMake(0, 0);
        _xRotateAngle = 0.0;
        _yRotateAngle = 0.0;
        _zRotateAngle = -90.0;
        
        [self setupLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [self setupFrameAndRenderBuffer];
    if (self.frame.size.height != _viewSize.height ||
        self.frame.size.width != _viewSize.width) {
        _viewSize = self.frame.size;
        //由于有旋转90度处理，这里需要专门处理
        
        CGSize temp = _videoFrameSize;
        
        if (((int)(_zRotateAngle) % 180) != 0) {
            //由于有旋转90度处理，这里需要专门处理
            temp = CGSizeMake(_videoFrameSize.height, _videoFrameSize.width);
        }
        
        _rcViewport = [self calculateViewPortRect:_viewSize withImageSize:temp];
    }
    
    //主线程
//    dispatch_async([GLiveGLShareInstance shareInstance].cellLayoutQueue , ^{
//
//    });
}


#pragma mark - Setup
- (void)setupLayer
{
    _eaglLayer.contentsScale = _contentScale;
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    _eaglLayer.contentsScale = _contentScale;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}
- (void)setupFrameAndRenderBuffer
{
    if (_render == nil) {
        return;
    }
    
    [_render userCurrentContext];
    [self destoryRenderAndFrameBuffer];
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    // 为 color renderbuffer 分配存储空间
    //self.layer.contentsScale = [UIScreen mainScreen].scale;
    [_render.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)useCurrentProgram
{
    [_render userCurrentGLProgram];
}

#pragma mark - Clean
- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

#pragma mark - Render
- (void)draw
{
    if(_render == nil)
    {
        return;
    }
    
    [_render userCurrentContext];
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //glViewport(0,0,_viewSize.width,_viewSize.height);
    //CGFloat scale = [UIScreen mainScreen].scale;
    glViewport(_rcViewport.origin.x*_contentScale, _rcViewport.origin.y*_contentScale, _rcViewport.size.width*_contentScale, _rcViewport.size.height*_contentScale);
    
    // 绘制
    [_render prepareRender];
}

- (void)clearVideoFrame
{
    [_render userCurrentContext];
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_render.context presentRenderbuffer:GL_RENDERBUFFER];
}

-(CGRect)calculateViewPortRect: (CGSize)viewSize withImageSize:(CGSize)imageSize
{
    CGRect rcViewPort;
    rcViewPort.origin.x = 0;
    rcViewPort.origin.y = 0;
    rcViewPort.size = viewSize;
    if (imageSize.height == 0 ||
        imageSize.width == 0 ||
        viewSize.height == 0 ||
        viewSize.width == 0) {
        return rcViewPort;
    }

    CGFloat wDiff = viewSize.width - imageSize.width;
    CGFloat hDiff = viewSize.height - imageSize.height;
    
    CGFloat ratioWH = imageSize.width / imageSize.height;
    CGFloat ratioHW = imageSize.height / imageSize.width;
    
    CGFloat wIncX = fabs(ratioWH*hDiff);
    CGFloat hIncX = fabs(ratioHW*wDiff);
    
    if (wDiff > 0 || hDiff > 0){
        //需要拉伸
        if ((hDiff > 0) && (wDiff < 0)) {
            rcViewPort.size.height = viewSize.height;
            rcViewPort.size.width  = rcViewPort.size.height*ratioWH;
        }else if((wDiff > 0 ) && (hDiff < 0))
        {
            rcViewPort.size.width = viewSize.width;
            rcViewPort.size.height = rcViewPort.size.width*ratioHW;
        }else if((wDiff > 0) && (hDiff > 0))
        {
            if (wIncX > wDiff) {
                //优先填满H方向
                rcViewPort.size.height = viewSize.height;
                rcViewPort.size.width = rcViewPort.size.height*ratioWH;
            }else{
                //优先填满W方向
                rcViewPort.size.width = viewSize.width;
                rcViewPort.size.height= rcViewPort.size.width*ratioHW;
            }
        }
    }else if((wDiff == 0) && (hDiff == 0)){
        //do nothing
    }else if((wDiff < 0) && (hDiff < 0)){
        //需要压缩
        wDiff = -wDiff;
        hDiff = -hDiff;
        
        if (imageSize.width - wIncX > viewSize.width ) {
            //以H作压缩参考
            rcViewPort.size.height = viewSize.height;
            rcViewPort.size.width = rcViewPort.size.height*ratioWH;
        }else{
            //以W作压缩参考
            rcViewPort.size.width = viewSize.width;
            rcViewPort.size.height = rcViewPort.size.width*ratioHW;
        }
    }
    
    //让viewport居中
    CGFloat originxoffset = (rcViewPort.size.width - viewSize.width)/2;
    CGFloat originyoffset = (rcViewPort.size.height - viewSize.height)/2;
    
    rcViewPort.origin.x = -originxoffset;
    rcViewPort.origin.y = -originyoffset;
    return rcViewPort;
}

#pragma mark - PublicMethod
- (void)setRender:(GLiveGLRender *)render
{
    _render = render;
}

- (void)setTexture:(GLTexture *)texture
{
    CGSize size;
    size.width =  texture.width;
    size.height = texture.height;
    
    if ((_render == nil) ||
        (texture.width != _videoFrameSize.width) ||
        (texture.height != _videoFrameSize.height)) {
        
        [self allocNewRender:texture texSize:size];
        [_render setRotationWithDegree:_zRotateAngle withAxis:GLive_Rotation_Axis_Z withType:GLive_Rotation_Type_Vertex];
        [_render setRotationWithDegree:_yRotateAngle withAxis:GLive_Rotation_Axis_Y withType:GLive_Rotation_Type_Vertex];
        [_render setRotationWithDegree:_xRotateAngle withAxis:GLive_Rotation_Axis_X withType:GLive_Rotation_Type_Vertex];
        
        //由于有旋转90度处理，这里需要专门处理
        _videoFrameSize = size;
        CGSize temp = _videoFrameSize;
        
        if (((int)(_zRotateAngle) % 180) != 0) {
            //由于有旋转90度处理，这里需要专门处理
            temp = CGSizeMake(_videoFrameSize.height, _videoFrameSize.width);
        }
        if (_contentScale == 3) {
            _rcViewport = [self calculateViewPortRect:_viewSize withImageSize:temp];
        }

    }
    [_render setTexture:texture];
}

-(BOOL) allocNewRender:(GLTexture *)texture
               texSize:(CGSize)size
{
    if ([texture isMemberOfClass:[GLTextureRGB class]])
    {
        _render = [[GLiveGLRenderRGB alloc] initWithSize:size];
        [self setupFrameAndRenderBuffer];
        return YES;
    }else if([texture isMemberOfClass:[GLTextureYUV class]])
    {
        _render = [[GLiveGLRenderYUV alloc] initWithSize:size];
        [self setupFrameAndRenderBuffer];
        return YES;
    }
    return NO;
}

- (void)setNeedDraw
{
    [self draw];
}

@end
