#import "GLiveMp4RenderView.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import "GLiveGLShareInstance.h"


@interface GLiveMp4RenderView()
{
    CVPixelBufferRef    _lastImage;
    int                 _tryLockErrorCount;
    BOOL                _didSetupGL;
    BOOL                _didStopGL;
    GLfloat             _prevScaleFactor;
    BOOL                _didRelayoutSubViews;
    //eGLiveVideoSrcType  _videoSrcType;
}
@end

@implementation GLiveMp4RenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //[self setupLayer];
        
        _tryLockErrorCount = 0;
        self.glActiveLock = [[NSRecursiveLock alloc] init];
        
        //_videoSrcType = GLIVE_VIDEO_SRC_TYPE_SCREEN;
        _viewSize = frame.size;
        
        [GLiveGLShareInstance shareInstance].cellLayoutQueue;
        _contentScale = 1;
        _render = nil;
        [self setupGLOnce];
    }
    return self;
}

-(void)dealloc
{
    if (_render) {
        //[_render release];
        _render = nil;
    }
    //[super dealloc];
}


#pragma mark - Setup
//- (void)setupLayer
//{
//    _eaglLayer = (CAEAGLLayer*) self.layer;
//
//    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
//    _eaglLayer.opaque = NO;
//
//    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
//    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
//}

- (BOOL)setupEAGLContext:(EAGLContext *)context
{
    glGenFramebuffers(1, &_frameBuffer);
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x\n", status);
        return NO;
    }
    GLenum glError = glGetError();
    if (GL_NO_ERROR != glError) {
        NSLog(@"failed to setup GL %x\n", glError);
        return NO;
    }
    
    return YES;
}

- (BOOL)setupGLOnce
{
    if (_didSetupGL)
        return YES;
    
    if ([self isApplicationActive] == NO)
        return NO;
    
    __block BOOL didSetup = NO;
    if ([NSThread isMainThread]) {
        didSetup = [self setupGLGuarded];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            didSetup = [self setupGLGuarded];
        });
    }
    
    return didSetup;
}

- (BOOL) tryLockGLActive
{
    if (![self.glActiveLock tryLock])
        return NO;
    
    if (self.glActivePaused) {
        [self.glActiveLock unlock];
        return NO;
    }
    
    return YES;
}

- (void) lockGLActive
{
    [self.glActiveLock lock];
}

- (BOOL)setupGL
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
    eaglLayer.opaque = NO;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                    nil];
    
    _scaleFactor = [[UIScreen mainScreen] scale];
    if (_scaleFactor < 0.1f)
        _scaleFactor = 1.0f;
    _prevScaleFactor = _scaleFactor;
    
    [eaglLayer setContentsScale:_scaleFactor];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (_context == nil) {
        NSLog(@"failed to setup EAGLContext\n");
        return NO;
    }
    
    EAGLContext *prevContext = [EAGLContext currentContext];
    [EAGLContext setCurrentContext:_context];
    
    _didSetupGL = NO;
    if ([self setupEAGLContext:_context]) {
        NSLog(@"OK setup GL\n");
        _didSetupGL = YES;
    }
    
    [EAGLContext setCurrentContext:prevContext];
    return _didSetupGL;
}

- (BOOL)setupGLGuarded
{
    if (![self tryLockGLActive]) {
        return NO;
    }
    
    BOOL didSetupGL = [self setupGL];
    [self unlockGLActive];
    return didSetupGL;
}

- (void) unlockGLActive
{
    @synchronized(self) {
        [self.glActiveLock unlock];
    }
}

- (BOOL)isApplicationActive
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    switch (appState) {
        case UIApplicationStateActive:
            return YES;
        case UIApplicationStateInactive:
        case UIApplicationStateBackground:
        default:
            return NO;
    }
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _didRelayoutSubViews = YES;
}

- (void)layoutOnDisplayThread
{
    int backingWidth  = 0;
    int backingHeight = 0;
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
//    if (_backingWidth != backingWidth || _backingHeight != backingHeight) {
//        _backingWidth  = backingWidth;
//        _backingHeight = backingHeight;
//        //_didVerticesChanged = YES;
//    }
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        
        NSLog(@"failed to make complete framebuffer object %x", status);
        
    } else {
        //NSLog(@"OK setup GL framebuffer %d:%d", _backingWidth, _backingHeight);
    }
}

-(BOOL) allocNewRender:(GLTexture *)texture
               texSize:(CGSize)size
{
    if([texture isMemberOfClass:[GLTexturePixelBuffer class]])
    {
        if(_render != nil)
        {
            //[_render release];
        }
        
        _render = [[GLiveGLRenderPixelBuffer alloc] initWithSize:size withContext:_context];
        //[self setupFrameAndRenderBuffer];
        return YES;
    }
    return NO;
}

//- (void)destoryRenderAndFrameBuffer
//{
//    glDeleteFramebuffers(1, &_frameBuffer);
//    _frameBuffer = 0;
//    glDeleteRenderbuffers(1, &_colorRenderBuffer);
//    _colorRenderBuffer = 0;
//}
//
//- (void)setupFrameAndRenderBuffer
//{
//    if(_render == nil || _eaglLayer == nil){
//        return;
//    }
//    [_render userCurrentContext];
//    [self destoryRenderAndFrameBuffer];
//
//    glGenRenderbuffers(1, &_colorRenderBuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
//    _contentScale = [UIScreen mainScreen].scale;
//    _eaglLayer.contentsScale = _contentScale;
//
//    // 为 color renderbuffer 分配存储空间
//    [_render.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
//
//    glGenFramebuffers(1, &_frameBuffer);
//    // 设置为当前 framebuffer
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
//                              GL_RENDERBUFFER, _colorRenderBuffer);
//}

- (void)setTexture:(GLTexture *)texture
{
    CGSize size;
    size.width =  texture.width;
    size.height = texture.height;
    if((_render == nil) ||
       (size.width != _render.width) ||
       (size.height!= _render.height))
    {
        [self allocNewRender:texture texSize:size];
        _render.yuvTypeValue = 2;
//        [_render setRotationWithDegree:_yRotateAngle
//                              withAxis:GLive_Rotation_Axis_Y
//                              withType:GLive_Rotation_Type_Vertex];
//        [_render setRotationWithDegree:_xRotateAngle
//                              withAxis:GLive_Rotation_Axis_X
//                              withType:GLive_Rotation_Type_Vertex];
        
        _videoFrameSize = size;
        _rcViewport = CGRectMake(0, 0, _viewSize.width, _viewSize.height);
        NSLog(@"setTexture: _rcViewport x=%0.2f, y=%0.2f, w=%0.2f, h=%0.2f", _rcViewport.origin.x, _rcViewport.origin.y, _rcViewport.size.width, _rcViewport.size.height);
    }
    
    
    //[_render setTexture:texture];
    [self displayInternal:texture];
    //[self drawVideoFrame];
//    if(self.hidden == YES)  //UIView已被清透明色，新的视频帧上屏后无法显示，需要做恢复处理
//        self.hidden = NO;
}

- (void)displayInternal: (GLTexture *)texture
{
    if (texture == nil) {
        return;
    }
    
    CGSize size;
    size.width =  texture.width;
    size.height = texture.height;
    if((_render == nil) ||
       (size.width != _render.width) ||
       (size.height!= _render.height))
    {
        [self allocNewRender:texture texSize:size];
        _render.yuvTypeValue = 2;        
        _videoFrameSize = size;
        _rcViewport = CGRectMake(0, 0, _viewSize.width, _viewSize.height);
        NSLog(@"setTexture: _rcViewport x=%0.2f, y=%0.2f, w=%0.2f, h=%0.2f", _rcViewport.origin.x, _rcViewport.origin.y, _rcViewport.size.width, _rcViewport.size.height);
    }
    
    
    CGFloat newScaleFactor = _scaleFactor;
    if (_prevScaleFactor != newScaleFactor) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        [eaglLayer setContentsScale:newScaleFactor];
        
        _prevScaleFactor = newScaleFactor;
    }
    
    if (_didRelayoutSubViews) {
        _didRelayoutSubViews = NO;
        [self layoutOnDisplayThread];
    }
    
    [_render setTexture:texture];
    
    [_render userCurrentContext];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, newScaleFactor*_viewSize.width, newScaleFactor*_viewSize.height);
    [_render prepareRender];
    
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
//    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawVideoFrame
{
    if (_render == nil) {
        return;
    }
    
    [_render userCurrentContext];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    NSLog(@"applechangglive drawVideoFrame: _rcViewport x=%0.2f, y=%0.2f, w=%0.2f, h=%0.2f", _rcViewport.origin.x, _rcViewport.origin.y, _rcViewport.size.width, _rcViewport.size.height);
    
//    glViewport(_rcViewport.origin.x * _contentScale, _rcViewport.origin.y*_contentScale,
//               _rcViewport.size.width*_contentScale, _rcViewport.size.height*_contentScale);
    
    glViewport(0* _contentScale, 0*_contentScale,
               _viewSize.width*_contentScale, _viewSize.height*_contentScale);
    [_render prepareRender];
}


- (void)setMp4VideoFrame:(CVPixelBufferRef)pixelBuffer
{
    if(pixelBuffer == nil)
    {
        return;
    }
    
    
    _lastFrameTime = CACurrentMediaTime();
    
    //dispatch_sync([GLiveGLShareInstance shareInstance].cellLayoutQueue, ^() {
        GLTexturePixelBuffer* texture = [[GLTexturePixelBuffer alloc] initWithTextureCache:pixelBuffer];
        [self displayInternal:texture];
    //});
}
@end
