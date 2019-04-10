/*
 * IJKSDLGLView.m
 *
 * Copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
 *
 * based on https://github.com/kolyvan/kxmovie
 *
 * This file is part of ijkPlayer.
 *
 * ijkPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ijkPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ijkPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import "GLView.h"
#import "GLRenderNV12.h"
#define SYSTEMVERSION(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


static NSString *const g_vertexShaderString = IJK_SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 texcoord;
    uniform mat4 modelViewProjectionMatrix;
    varying vec2 v_texcoord;

    void main()
    {
        gl_Position = modelViewProjectionMatrix * position;
        v_texcoord = texcoord.xy;
    }
);

static BOOL validateProgram(GLuint prog)
{
	GLint status;

    glValidateProgram(prog);

#ifdef DEBUG
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == GL_FALSE) {
		NSLog(@"Failed to validate program %d", prog);
        return NO;
    }

	return YES;
}

static GLuint compileShader(GLenum type, NSString *shaderString)
{
	GLint status;
	const GLchar *sources = (GLchar *)shaderString.UTF8String;

    GLuint shader = glCreateShader(type);
    if (shader == 0 || shader == GL_INVALID_ENUM) {
        NSLog(@"Failed to create shader %d", type);
        return 0;
    }

    glShaderSource(shader, 1, &sources, NULL);
    glCompileShader(shader);

#ifdef DEBUG
	GLint logLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        glDeleteShader(shader);
		NSLog(@"Failed to compile shader:\n");
        return 0;
    }

	return shader;
}

static void mat4f_LoadOrtho(float left, float right, float bottom, float top, float near, float far, float* mout)
{
	float r_l = right - left;
	float t_b = top - bottom;
	float f_n = far - near;
	float tx = - (right + left) / (right - left);
	float ty = - (top + bottom) / (top - bottom);
	float tz = - (far + near) / (far - near);

	mout[0] = 2.0f / r_l;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;

	mout[4] = 0.0f;
	mout[5] = 2.0f / t_b;
	mout[6] = 0.0f;
	mout[7] = 0.0f;

	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = -2.0f / f_n;
	mout[11] = 0.0f;

	mout[12] = tx;
	mout[13] = ty;
	mout[14] = tz;
	mout[15] = 1.0f;
}


@interface GLView()
@property(atomic,strong) NSRecursiveLock *glActiveLock;
@property(atomic) BOOL glActivePaused;
@end

@implementation GLView {
    EAGLContext     *_context;
    GLuint          _framebuffer;
    GLuint          _renderbuffer;
    GLint           _backingWidth;
    GLint           _backingHeight;
    GLuint          _program;
    GLint           _uniformMatrix;
    GLfloat         _vertices[8];
    GLfloat         _texCoords[8];

    int             _frameWidth;
    int             _frameHeight;
    int             _frameChroma;
    int             _frameSarNum;
    int             _frameSarDen;
    int             _rightPaddingPixels;
    GLfloat         _rightPadding;
    int             _bytesPerPixel;
    int             _frameCount;
    
    int64_t         _lastFrameTime;

    GLfloat         _prevScaleFactor;

    id<IJKSDLGLRender>        _renderer;
    CVOpenGLESTextureCacheRef _textureCache;

    BOOL            _didSetContentMode;
    BOOL            _didRelayoutSubViews;
    BOOL            _didVerticesChanged;
    BOOL            _didPaddingChanged;

    int             _tryLockErrorCount;
    BOOL            _didSetupGL;
    BOOL            _didStopGL;
    NSMutableArray *_registeredNotifications;

    dispatch_queue_t    _renderQueue;
    CVPixelBufferRef    _lastImage;
    struct SwsContext               *_swsContext;

    CGRect                 _rcViewport;
    CGSize                 _videoFrameSize;
    CGSize                 _viewSize;
}

enum {
	ATTRIBUTE_VERTEX,
   	ATTRIBUTE_TEXCOORD,
};

static int g_ijk_gles_queue_spec_key;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needAlignCenterClamp = NO;
        _tryLockErrorCount = 0;
        _frameChroma = FCC__VTB;
        self.glActiveLock = [[NSRecursiveLock alloc] init];
        _registeredNotifications = [[NSMutableArray alloc] init];
        [self registerApplicationObservers];

        dispatch_queue_attr_t attr = NULL;
        if (SYSTEMVERSION(@"8.0")) {
            attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
                                                           QOS_CLASS_USER_INTERACTIVE,
                                                           DISPATCH_QUEUE_PRIORITY_HIGH);
        }
        _renderQueue = dispatch_queue_create("gles", attr);
        dispatch_queue_set_specific(_renderQueue,
                                    &g_ijk_gles_queue_spec_key,
                                    &g_ijk_gles_queue_spec_key,
                                    NULL);

        _didSetupGL = NO;
        [self setupGLOnce];

        
    }

    return self;
}

- (BOOL)setupEAGLContext:(EAGLContext *)context
{
    glGenFramebuffers(1, &_framebuffer);
    glGenRenderbuffers(1, &_renderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);

    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x\n", status);
        return NO;
    }

    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_textureCache);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d\n", err);
        return NO;
    }

    GLenum glError = glGetError();
    if (GL_NO_ERROR != glError) {
        NSLog(@"failed to setup GL %x\n", glError);
        return NO;
    }

    _vertices[0] = -1.0f;  // x0
    _vertices[1] = -1.0f;  // y0
    _vertices[2] =  1.0f;  // ..
    _vertices[3] = -1.0f;
    _vertices[4] = -1.0f;
    _vertices[5] =  1.0f;
    _vertices[6] =  1.0f;  // x3
    _vertices[7] =  1.0f;  // y3

    _texCoords[0] = 0.0f;
    _texCoords[1] = 1.0f;
    _texCoords[2] = 1.0f;
    _texCoords[3] = 1.0f;
    _texCoords[4] = 0.0f;
    _texCoords[5] = 0.0f;
    _texCoords[6] = 1.0f;
    _texCoords[7] = 0.0f;

    _rightPadding = 0.0f;

    return YES;
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

- (void)dealloc
{
    [self lockGLActive];

    _didStopGL = YES;
    _renderer = nil;

    if (_renderQueue) {
        _renderQueue = nil;
    }

    EAGLContext *prevContext = [EAGLContext currentContext];
    [EAGLContext setCurrentContext:_context];

    if (_framebuffer) {
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }

    if (_renderbuffer) {
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = 0;
    }

    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }

    if (_textureCache) {
        CFRelease(_textureCache);
        _textureCache = 0;
    }

    [EAGLContext setCurrentContext:prevContext];

    _context = nil;

    [self unregisterApplicationObservers];

    [self unlockGLActive];
    @synchronized (self) {
        if(nil != _lastImage)
            CFRelease(_lastImage);
        _lastImage = nil;
    }
   
}

- (void)setScaleFactor:(CGFloat)scaleFactor
{
    _scaleFactor = scaleFactor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _didRelayoutSubViews = YES;
    CGSize newFrameSize = self.frame.size;
    if (newFrameSize.height != _viewSize.height ||
        newFrameSize.width != _viewSize.width) {
        _viewSize = newFrameSize;
        CGSize tempVideoFrameSize = _videoFrameSize;

        _rcViewport = [self calculateViewPortRect:_viewSize withImageSize:tempVideoFrameSize];
        NSLog(@"layoutSubviews: _rcViewport x=%0.2f, y=%0.2f, w=%0.2f, h=%0.2f", _rcViewport.origin.x, _rcViewport.origin.y, _rcViewport.size.width, _rcViewport.size.height);
        
    }
}

-(CGRect)calculateViewPortRect: (CGSize)viewSize
                 withImageSize:(CGSize)imageSize
{
    CGRect rcViewPort;
    rcViewPort.origin.x = 0;
    rcViewPort.origin.y = 0;
    rcViewPort.size = viewSize;
    
    if (imageSize.height == 0 || imageSize.width == 0 ||
        viewSize.height == 0  || viewSize.width == 0)
    {
        return rcViewPort;
    }
    
    CGFloat wDiff = viewSize.width - imageSize.width;
    CGFloat hDiff = viewSize.height - imageSize.height;
    
    CGFloat ratioWH = imageSize.width / imageSize.height;
    CGFloat ratioHW = imageSize.height / imageSize.width;
    
    CGFloat wIncX = fabs(ratioWH*hDiff);
    //CGFloat hIncY = fabs(ratioHW*wDiff);
    
    if(1)
    {
        //相机视频
        if (wDiff > 0 || hDiff > 0)
        {
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
    return rcViewPort;
}

- (void)layoutOnDisplayThread
{
    int backingWidth  = 0;
    int backingHeight = 0;
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);

    if (_backingWidth != backingWidth || _backingHeight != backingHeight) {
        _backingWidth  = backingWidth;
        _backingHeight = backingHeight;
        _didVerticesChanged = YES;
    }

    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
	if (status != GL_FRAMEBUFFER_COMPLETE) {

        NSLog(@"failed to make complete framebuffer object %x", status);

	} else {

        NSLog(@"OK setup GL framebuffer %d:%d", _backingWidth, _backingHeight);
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    _didSetContentMode = YES;
    if (self->_renderQueue) {
        dispatch_async(self->_renderQueue, ^(){
            [self display:nil];
        });
    }
}

- (BOOL)setupDisplay: (void *) overlay
{
    if (! overlay) {
        return 0;
    }
    
    if (_renderer == nil) {
        if (_frameChroma == FCC__VTB) {
            
            _renderer = [[IJKSDLGLRenderNV12 alloc] initWithTextureCache:_textureCache];
            _bytesPerPixel = 1;
            NSLog(@"OK use NV12 GL renderer");
        }

        if (![self loadShaders]) {
            return NO;
        }
    }

    if (overlay) {
         CVPixelBufferRef pixelBuffer = overlay;
        size_t frameWidth  = CVPixelBufferGetWidth(pixelBuffer);
        size_t frameHeight = CVPixelBufferGetHeight(pixelBuffer);

        if (_frameWidth  != frameWidth ||
            _frameHeight != frameHeight ) {
            _frameWidth  = frameWidth;
            _frameHeight = frameHeight;
            _videoFrameSize.height = frameHeight;
            _videoFrameSize.width = frameWidth/2;
            CGSize tempVideoFrameSize = _videoFrameSize;
            _rcViewport = [self calculateViewPortRect:_viewSize withImageSize:tempVideoFrameSize];
            _didVerticesChanged = YES;
         }

        //if (!overlay->is_private && overlay->pitches && _frameWidth > 0) {
        //    int frameBufferWidth   = overlay->pitches[0] / _bytesPerPixel;
        //    int rightPaddingPixels = frameBufferWidth - _frameWidth;
         //   if (rightPaddingPixels != _rightPaddingPixels) {
         //       _rightPaddingPixels = rightPaddingPixels;
         //       _rightPadding       = ((GLfloat)_rightPaddingPixels) frameBufferWidth;
          //  }
       // }
    }

    return YES;
}

- (BOOL)loadShaders
{
    BOOL result = NO;
    GLuint vertShader = 0, fragShader = 0;

	_program = glCreateProgram();

    vertShader = compileShader(GL_VERTEX_SHADER, g_vertexShaderString);
	if (!vertShader)
        goto exit;

	fragShader = compileShader(GL_FRAGMENT_SHADER, _renderer.fragmentShader);
    if (!fragShader)
        goto exit;

	glAttachShader(_program, vertShader);
	glAttachShader(_program, fragShader);
	glBindAttribLocation(_program, ATTRIBUTE_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIBUTE_TEXCOORD, "texcoord");

	glLinkProgram(_program);

    GLint status;
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
		NSLog(@"Failed to link program %d", _program);
        goto exit;
    }

    result = validateProgram(_program);

    _uniformMatrix = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    [_renderer resolveUniforms:_program];

exit:

    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);

    if (result) {

        NSLog(@"OK setup GL programm");

    } else {

        glDeleteProgram(_program);
        _program = 0;
    }

    return result;
}

- (void)updateVertices
{
    float width                 = _frameWidth;
    float height                = _frameHeight;
    const float dW              = (float)_backingWidth	/ width;
    const float dH              = (float)_backingHeight / height;
    float dd                    = 1.0f;
    float nW                    = 1.0f;
    float nH                    = 1.0f;

    if (_frameSarNum > 0 && _frameSarDen > 0) {
        width = width * _frameSarNum / _frameSarDen;
    }

    switch (self.contentMode) {
        case UIViewContentModeScaleToFill:
            break;
        case UIViewContentModeCenter:
            nW = 1.0f / dW / [UIScreen mainScreen].scale;
            nH = 1.0f / dH / [UIScreen mainScreen].scale;
            break;
        case UIViewContentModeScaleAspectFill:
            dd = MAX(dW, dH);
            nW = (width  * dd / (float)_backingWidth );
            nH = (height * dd / (float)_backingHeight);
            break;
        case UIViewContentModeScaleAspectFit:
        default:
            dd = MIN(dW, dH);
            nW = (width  * dd / (float)_backingWidth );
            nH = (height * dd / (float)_backingHeight);
            break;
    }

    _vertices[0] = - nW;
    _vertices[1] = - nH;
    _vertices[2] =   nW;
    _vertices[3] = - nH;
    _vertices[4] = - nW;
    _vertices[5] =   nH;
    _vertices[6] =   nW;
    _vertices[7] =   nH;
}

//- (UIImage*) getLastImage
//{
//@synchronized (self) {
//       if(_lastImage){
//        size_t width = CVPixelBufferGetWidth(_lastImage);
//        size_t height = CVPixelBufferGetHeight(_lastImage);
//        _swsContext = sws_getCachedContext(_swsContext, width, height, AV_PIX_FMT_NV12, width, height, AV_PIX_FMT_RGBA, SWS_FAST_BILINEAR,NULL, NULL, NULL);
//        CVPixelBufferLockBaseAddress(_lastImage, 0);
//        uint8_t* data[4];
//        uint8_t* RGBData[1];
//        uint32_t lineSize[4];
//        uint32_t RGBLineSize[4];
//        for (int i = 0; i < 2; i++) {
//            data[i] = (uint8_t*)CVPixelBufferGetBaseAddressOfPlane(_lastImage, i);
//            lineSize[i] = (uint32_t)CVPixelBufferGetBytesPerRowOfPlane(_lastImage, i);
//
//        }
//        RGBData[0] = malloc(width*height*4);
//        RGBLineSize[0] = width*4;
//        if(!RGBData[0])
//            return nil;
//
//        sws_scale(_swsContext, (const uint8_t* const*)data, lineSize, 0, height, RGBData, RGBLineSize);
//        CVPixelBufferUnlockBaseAddress(_lastImage,0);
//        UIImage* uiImage =  [self imageFromAVPicture:RGBData[0] width:width height:height];
//        free(RGBData[0]);
//        return uiImage;
//       }
//    }
//    return nil;
//}

-(UIImage *)imageFromAVPicture:(uint8_t*)pict width:(int)width height:(int)height {
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big|kCGImageAlphaPremultipliedLast;
    //CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
    CFDataRef data = CFDataCreate(kCFAllocatorDefault, pict, width*height*4);
    if (data == NULL) {
        NSLog(@"CFDataCreate failed! may be out of memory!");
        return nil;
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       32,
                                       width*4,
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
    return image;
}

- (void)display: (void *) overlay
{
    CFRetain(overlay);
    @synchronized (self) {
        if(_lastImage)
            CFRelease(_lastImage);
    }
   
    _lastImage = overlay;
    
    if (!dispatch_get_specific(&g_ijk_gles_queue_spec_key)) {
        dispatch_sync(self->_renderQueue, ^() {
            [self display:overlay];
        });
        return;
    }

    if ([self setupGLOnce]) {
        // gles throws gpus_ReturnNotPermittedKillClient, while app is in background
        if (![self tryLockGLActive]) {
            if (0 == (_tryLockErrorCount % 100)) {
                NSLog(@"GLView:display: unable to tryLock GL active: %d\n", _tryLockErrorCount);
            }
            CFRelease(overlay);
            _tryLockErrorCount++;
            return;
        }

        _tryLockErrorCount = 0;
        if (!_didStopGL) {
            if (_context == nil) {
                NSLog(@"GLView: nil EAGLContext\n");
                return;
            }

            EAGLContext *prevContext = [EAGLContext currentContext];
            [EAGLContext setCurrentContext:_context];
            [self displayInternal:overlay];
            [EAGLContext setCurrentContext:prevContext];
        }

        [self unlockGLActive];
    }
    CFRelease(overlay);
}

- (void)displayInternal: (void*) overlay
{
    CGFloat newScaleFactor = _scaleFactor;
    if (_prevScaleFactor != newScaleFactor) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        [eaglLayer setContentsScale:newScaleFactor];

        _prevScaleFactor = newScaleFactor;
    }

    if (![self setupDisplay:overlay]) {
        NSLog(@"GLView: setupDisplay failed\n");
        return;
    }

    if (_didRelayoutSubViews) {
        _didRelayoutSubViews = NO;
        [self layoutOnDisplayThread];
    }

    if (_didSetContentMode || _didVerticesChanged) {
        _didSetContentMode = NO;
        _didVerticesChanged = NO;
        [self updateVertices];
    }

    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    
    if (self.needAlignCenterClamp == YES) {
        glViewport(_rcViewport.origin.x * _scaleFactor, _rcViewport.origin.y*_scaleFactor,
                   _rcViewport.size.width*_scaleFactor, _rcViewport.size.height*_scaleFactor);
    }else{
        glViewport(0, 0, _backingWidth, _backingHeight);
    }
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	glUseProgram(_program);

    if (overlay) {
        [_renderer render:overlay];
    }

    if ([_renderer prepareDisplay]) {
        _texCoords[0] = 0.0f;
        _texCoords[1] = 1.0f;
        _texCoords[2] = 1.0f - _rightPadding;
        _texCoords[3] = 1.0f;
        _texCoords[4] = 0.0f;
        _texCoords[5] = 0.0f;
        _texCoords[6] = 1.0f - _rightPadding;
        _texCoords[7] = 0.0f;

        GLfloat modelviewProj[16];
        mat4f_LoadOrtho(-1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f, modelviewProj);
        glUniformMatrix4fv(_uniformMatrix, 1, GL_FALSE, modelviewProj);

        glVertexAttribPointer(ATTRIBUTE_VERTEX, 2, GL_FLOAT, 0, 0, _vertices);
        glEnableVertexAttribArray(ATTRIBUTE_VERTEX);
        glVertexAttribPointer(ATTRIBUTE_TEXCOORD, 2, GL_FLOAT, 0, 0, _texCoords);
        glEnableVertexAttribArray(ATTRIBUTE_TEXCOORD);

#if 0
        if (!validateProgram(_program))
        {
            NSLog(@"Failed to validate program");
            return;
        }
#endif

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

        glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
        [_context presentRenderbuffer:GL_RENDERBUFFER];

      //  int64_t current = (int64_t)SDL_GetTickHR();
      //  int64_t delta   = (current > _lastFrameTime) ? current - _lastFrameTime : 0;
      //  if (delta <= 0) {
      //      _lastFrameTime = current;
      //  } else if (delta >= 1000) {
       //     _fps = ((CGFloat)_frameCount) * 1000 / delta;
       //     _frameCount = 0;
        //    _lastFrameTime = current;
       // } else {
        //    _frameCount++;
        //}
    }
}

#pragma mark AppDelegate

- (void) lockGLActive
{
    [self.glActiveLock lock];
}

- (void) unlockGLActive
{
    @synchronized(self) {
        [self.glActiveLock unlock];
    }
}

- (BOOL) tryLockGLActive
{
    if (![self.glActiveLock tryLock])
        return NO;

    /*-
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive &&
        [UIApplication sharedApplication].applicationState != UIApplicationStateInactive) {
        [self.appLock unlock];
        return NO;
    }
     */

    if (self.glActivePaused) {
        [self.glActiveLock unlock];
        return NO;
    }
    
    return YES;
}

- (void)toggleGLPaused:(BOOL)paused
{
    [self lockGLActive];
    self.glActivePaused = paused;
    [self unlockGLActive];
}

- (void)registerApplicationObservers
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [_registeredNotifications addObject:UIApplicationWillEnterForegroundNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [_registeredNotifications addObject:UIApplicationDidBecomeActiveNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [_registeredNotifications addObject:UIApplicationWillResignActiveNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [_registeredNotifications addObject:UIApplicationDidEnterBackgroundNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [_registeredNotifications addObject:UIApplicationWillTerminateNotification];
}

- (void)unregisterApplicationObservers
{
    for (NSString *name in _registeredNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
}

- (void)applicationWillEnterForeground
{
    NSLog(@"IJKSDLGLView:applicationWillEnterForeground: %d", (int)[UIApplication sharedApplication].applicationState);
    [self toggleGLPaused:NO];
}

- (void)applicationDidBecomeActive
{
    NSLog(@"IJKSDLGLView:applicationDidBecomeActive: %d", (int)[UIApplication sharedApplication].applicationState);
    [self toggleGLPaused:NO];
}

- (void)applicationWillResignActive
{
    NSLog(@"IJKSDLGLView:applicationWillResignActive: %d", (int)[UIApplication sharedApplication].applicationState);
    [self toggleGLPaused:YES];
}

- (void)applicationDidEnterBackground
{
    NSLog(@"IJKSDLGLView:applicationDidEnterBackground: %d", (int)[UIApplication sharedApplication].applicationState);
    [self toggleGLPaused:YES];
}

- (void)applicationWillTerminate
{
    NSLog(@"IJKSDLGLView:applicationWillTerminate: %d", (int)[UIApplication sharedApplication].applicationState);
    [self toggleGLPaused:YES];
}






@end
