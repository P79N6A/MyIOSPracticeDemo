#import "GLRender.h"

#define LIVE_HOSTESS_TO_BE_PROCESSED_FRAME_MAX 30
#define LIVE_RECEV_TO_BE_PROCESSED_FRAME_MAX   30

@implementation GLiveGLRender

-(instancetype)initWithSize:(CGSize)texSize
{
    if (self = [super init])
    {
        for (int i=0; i<9; i++)
        {
            if (i%4 == 0) {
                _xRotateMatrix[i] = 1;
                _yRotateMatrix[i] = 1;
                _zRotateMatrix[i] = 1;
            }else{
                _xRotateMatrix[i] = 0;
                _yRotateMatrix[i] = 0;
                _zRotateMatrix[i] = 0;
            }
        }
        
        _texTopLeft.x = 0;
        _texTopLeft.y = 0;
        _texBottomLeft.x = 0;
        _texBottomLeft.y = 1;
        _texTopRight.x = 1;
        _texTopRight.y = 0;
        _texBottomRight.x = 1;
        _texBottomRight.y = 1;
        self.yuvTypeValue = 0;
        
        [self setupContext];
    }
    return self;
}

-(void)dealloc
{
}

- (void)setupContext
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        //GLiveLogFinal("Failed to initialize OpenGLES 2.0 context");
    }

    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        //GLiveLogFinal("Failed to set current OpenGL context");
    }
}

- (void)setupVBO
{
    /*
    GLfloat glivetexCoords[] = {
        1.0f, 0.0f, //右上
        1.0f, 1.0f, //右下
        0.0f, 1.0f, //左下
        0.0f, 0.0f, //左上
    };
    */
    
    GLfloat glivetexCoords[] = {
        _texTopRight.x,    _texTopRight.y,    //右上
        _texBottomRight.x, _texBottomRight.y, //右下
        _texBottomLeft.x,  _texBottomLeft.y,  //左下
        _texTopLeft.x,     _texTopLeft.y,     //左上
    };
    
    glGenBuffers(1, &_textureVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(glivetexCoords), glivetexCoords, GL_DYNAMIC_DRAW);
    
    const GLfloat vertices[] = {
        1.0f,  1.0f,  0,      //右上
        1.0f,  -1.0f, 0,      //右下
        -1.0f, -1.0f, 0,      //左下
        -1.0f,  1.0f, 0,      //左上
    };
    
    glGenBuffers(1, &_vertexVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    const GLubyte indices[] = {
        0,1,2,
        2,3,0
    };
    glGenBuffers(1, &_indexVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_DYNAMIC_DRAW);
    _indexCount = sizeof(indices)/sizeof(indices[0]);
}

- (void) setRotationWithDegree:(float)degrees
                      withAxis:(GLIVE_VIDEO_ROTATE_AXIS)axis
                      withType:(GLIVE_VIDEO_ROTATE_TYPE)rotateType;
{
    float radians = degrees * 3.14159f / 180.0f;
    float s = sin(radians);
    float c = cos(radians);
    
    if (GLive_Rotation_Type_Vertex == rotateType) {
        if (axis == GLive_Rotation_Axis_X) {

            //[1.0, 0.0, 0.0,
            // 0.0, c, s,
            //0.0, -s, c]
            _xRotateMatrix[4] = c;
            _xRotateMatrix[5] = s;
            _xRotateMatrix[7] = -s;
            _xRotateMatrix[8] = c;
        }else if(axis == GLive_Rotation_Axis_Y)
        {
            //[c, 0.0, -s,
            // 0.0, 1.0, 0.0,
            //-s, 0.0, c]
            _yRotateMatrix[0] = c;
            _yRotateMatrix[2] = -s;
            _yRotateMatrix[6] = -s;
            _yRotateMatrix[8] = c;
        }else if(axis == GLive_Rotation_Axis_Z)
        {
            //[c, s, 0.0,
            //-s, c, 0.0,
            //0.0, 0.0, 1.0]
            
            _zRotateMatrix[0] = c;
            _zRotateMatrix[1] = s;
            _zRotateMatrix[3] = -s;
            _zRotateMatrix[4] = c;
        }
    }
}

- (void)prepareRender
{
}

- (void)setTexture:(GLTexture *)texture
{
}

-(void)clearRenderBuffer
{
    [self userCurrentContext];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)setupGLProgram
{
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag.glsl" ofType:nil];
    
    NSError* error = nil;
    NSString* vertString = [NSString stringWithContentsOfFile:vertFile
                                                     encoding:NSUTF8StringEncoding error:&error];
    if (!vertString) {
        NSLog(@"Error loading shader: %@, error: %@", vertFile, error.localizedDescription);
        exit(1);
    }
    
    NSString* fragString = [NSString stringWithContentsOfFile:fragFile
                                                     encoding:NSUTF8StringEncoding error:&error];
    if (!fragString) {
        NSLog(@"Error loading shader: %@, error: %@", fragString, error.localizedDescription);
        exit(1);
    }
    
    self.glProgram = createGLProgram(vertString.UTF8String, fragString.UTF8String);
    glUseProgram(self.glProgram);
    
    _yuvTypeUniform = glGetUniformLocation(self.glProgram, "yuvType");
    
    _rotateXMatrixUniform = glGetUniformLocation(self.glProgram, "rotateXMatrix");
    _rotateYMatrixUniform = glGetUniformLocation(self.glProgram, "rotateYMatrix");
    _rotateZMatrixUniform = glGetUniformLocation(self.glProgram, "rotateZMatrix");
}

-(void)userCurrentContext
{
    if (self.context && [EAGLContext setCurrentContext:self.context]) {
        NSLog(@"Success to set current OpenGL context");
    }else{
        NSLog(@"Failed to set current OpenGL context");
    }
}

-(void)userCurrentGLProgram;
{
    glUseProgram(self.glProgram);
}

- (void)drawTexture:(GLTexture *)texture viewX:(GLint)x viewY:(GLint)y viewWidth:(GLsizei)width viewHeight:(GLsizei)height
{
    
}

@end

@implementation GLiveGLRenderRGB
- (instancetype)initWithSize:(CGSize)texSize
{
    if (self = [super initWithSize:texSize]) {
        [self setupGLProgram];
        [self setupVBO];
        
        self.height = texSize.height;
        self.width = texSize.width;
        _rgbTexture = createTexture2D(GL_RGBA, texSize.width, texSize.height, NULL);
    }
    return self;
}

- (void)setupGLProgram
{
}


- (void)setTexture:(GLTexture *)texture
{
    if ([texture isMemberOfClass:[GLTextureRGB class]]) {
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        GLTextureRGB *rgbTexture = (GLTextureRGB *)texture;
        glBindTexture(GL_TEXTURE_2D, _rgbTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width, texture.height, GL_RGBA, GL_UNSIGNED_BYTE, rgbTexture.RGBA);
    }
}

-(void)clearRenderBuffer
{
    [self userCurrentContext];
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)prepareRender
{
    [self userCurrentGLProgram];
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "texcoord"));
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "position"));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _rgbTexture);
    glUniform1i(glGetUniformLocation(self.glProgram, "image0"), 0);
    
    glUniformMatrix3fv(_rotateXMatrixUniform, 1, 0, _xRotateMatrix);
    glUniformMatrix3fv(_rotateYMatrixUniform, 1, 0, _yRotateMatrix);
    glUniformMatrix3fv(_rotateZMatrixUniform, 1, 0, _zRotateMatrix);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glDrawElements(GL_TRIANGLE_STRIP, _indexCount, GL_UNSIGNED_BYTE, 0);
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}
@end

////////////////GLRenderYUV//////////////////////////
@implementation GLiveGLRenderYUV

- (instancetype)initWithSize:(CGSize)texSize
{
    if (self = [super initWithSize:texSize]) {
        _renderFrameBuffer = [NSMutableArray arrayWithCapacity: LIVE_RECEV_TO_BE_PROCESSED_FRAME_MAX];
        _curRenderTexture = nil;
        self.height = texSize.height;
        self.width = texSize.width;
        
        if ((texSize.height == 480) && (texSize.width == 640))
        {
            //由于流控配置里会是368,所有要调整纹理高度贴图区域，为了进度，暂时只能做这种丑陋的事了
            int offsetH = (480 - 368)/(2*480);
            _texTopLeft.y += offsetH;
            _texTopRight.y += offsetH;
            _texBottomLeft.y -= offsetH;
            _texBottomRight.y -= offsetH;
        }
        [self setupGLProgram];
        [self setupVBO];
        
        _yPlaneTexture = createTexture2D(GL_LUMINANCE, texSize.width, texSize.height, NULL);
        _uPlaneTexture = createTexture2D(GL_LUMINANCE, texSize.width/2, texSize.height/2, NULL);
        _vPlaneTexture = createTexture2D(GL_LUMINANCE, texSize.width/2, texSize.height/2, NULL);
    }
    return self;
}

-(void)dealloc
{
    //[EAGLContext setCurrentContext:self.context];
    [self userCurrentContext];
    glDeleteProgram(self.glProgram);
    self.glProgram = 0;
    
    glDeleteBuffers(1, &_vertexVBO);
    _vertexVBO = 0;
    
    glDeleteBuffers(1, &_indexVBO);
    _indexVBO = 0;
    
    glDeleteBuffers(1, &_textureVBO);
    _textureVBO = 0;
    
    glDeleteTextures(1, &_yPlaneTexture);
    _yPlaneTexture = 0;
    
    glDeleteTextures(1, &_uPlaneTexture);
    _uPlaneTexture = 0;
    
    glDeleteTextures(1, &_vPlaneTexture);
    _vPlaneTexture = 0;
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }

    self.context = nil;
    _curRenderTexture = nil;
}

- (void)setupGLProgram
{
    [super setupGLProgram];
    _yPlaneUniform = glGetUniformLocation(self.glProgram, "yPlane");
    _uPlaneUniform = glGetUniformLocation(self.glProgram, "uPlane");
    _vPlaneUniform = glGetUniformLocation(self.glProgram, "vPlane");
}

- (void)setTexture:(GLTexture *)texture
{
    _curRenderTexture = texture;
}

- (void)drawTexture:(GLTexture *)texture viewX:(GLint)x viewY:(GLint)y viewWidth:(GLsizei)width viewHeight:(GLsizei)height
{
    [self userCurrentContext];
    [self userCurrentGLProgram];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(x, y, width, height);
    [self bindTexture:texture];
 
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "texcoord"));
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "position"));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _yPlaneTexture);
    glUniform1i(_yPlaneUniform, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _uPlaneTexture);
    glUniform1i(_uPlaneUniform, 1);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _vPlaneTexture);
    glUniform1i(_vPlaneUniform, 2);
    
    glUniformMatrix3fv(_rotateXMatrixUniform, 1, 0, _xRotateMatrix);
    glUniformMatrix3fv(_rotateYMatrixUniform, 1, 0, _yRotateMatrix);
    glUniformMatrix3fv(_rotateZMatrixUniform, 1, 0, _zRotateMatrix);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);

    glDrawElements(GL_TRIANGLE_STRIP, _indexCount, GL_UNSIGNED_BYTE, 0);
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void) bindTexture:(GLTexture*)texture
{
    if (texture == nil) {
        return;
    }
    
    if ([texture isMemberOfClass:[GLTextureYUV class]]) {
        GLTextureYUV *yuvTexture = (GLTextureYUV *)texture;
        
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        glBindTexture(GL_TEXTURE_2D, _yPlaneTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width, texture.height, GL_LUMINANCE, GL_UNSIGNED_BYTE, yuvTexture.Y);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_2D, _uPlaneTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width/2, texture.height/2, GL_LUMINANCE, GL_UNSIGNED_BYTE, yuvTexture.U);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_2D, _vPlaneTexture);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width/2, texture.height/2, GL_LUMINANCE, GL_UNSIGNED_BYTE, yuvTexture.V);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
}

- (void)prepareRender
{
    if (![_curRenderTexture isMemberOfClass:[GLTextureYUV class]]) {
        return;
    }
    
    GLTextureYUV *yuvTexture = (GLTextureYUV *)_curRenderTexture;
    if (yuvTexture == nil) {
        return;
    }
    
//    if ([yuvTexture getDirtyFlag] == YES) {
//        if ([yuvTexture getAsMemHolder] == NO) {
//            //如果该帧已经使用过且他的帧数据没有自己持有，就不要绘制，可能外部释放了
//            return;
//        }
//    }
//
//    [yuvTexture setDirtyFlag:YES];
    
    
    [self userCurrentContext];
    [self userCurrentGLProgram];
    
    glUniform1i(_yuvTypeUniform, self.yuvTypeValue);
    [self bindTexture:_curRenderTexture];
    
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "texcoord"));

    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "position"));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _yPlaneTexture);
    glUniform1i(_yPlaneUniform, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _uPlaneTexture);
    glUniform1i(_uPlaneUniform, 1);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _vPlaneTexture);
    glUniform1i(_vPlaneUniform, 2);
    
    glUniformMatrix3fv(_rotateXMatrixUniform, 1, 0, _xRotateMatrix);
    glUniformMatrix3fv(_rotateYMatrixUniform, 1, 0, _yRotateMatrix);
    glUniformMatrix3fv(_rotateZMatrixUniform, 1, 0, _zRotateMatrix);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glDrawElements(GL_TRIANGLE_STRIP, _indexCount, GL_UNSIGNED_BYTE, 0);
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [self.context presentRenderbuffer:GL_RENDERBUFFER];

}

-(void)userCurrentContext
{
    if (self.context && [EAGLContext setCurrentContext:self.context]) {
        NSLog(@"Success to set current OpenGL context");
    }else{
        NSLog(@"Failed to set current OpenGL context");
    }
}

-(void)userCurrentGLProgram;
{
    glUseProgram(self.glProgram);
}

@end


@implementation GLiveGLRenderPixelBuffer
- (instancetype)initWithSize:(CGSize)texSize withContext:(EAGLContext*) context;
{
    if (self = [super initWithSize:texSize]) {
        [self setupGLProgram];
        [self setupVBO];
        
        self.height = texSize.height;
        self.width = texSize.width;
        self.context = context;
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, self.context, NULL, &_textureCache);
        if (err) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d\n", err);
        }
    }
    return self;
}

- (void)setupContext
{
    //do nothing
}

- (void)setTexture:(GLTexture *)texture
{
    if ([texture isMemberOfClass:[GLTexturePixelBuffer class]]) {
        GLTexturePixelBuffer *pixelBufTexture = (GLTexturePixelBuffer *)texture;
        
        for (int i = 0; i < 2; ++i) {
            if (_cvTexturesRef[i]) {
                CFRelease(_cvTexturesRef[i]);
                _cvTexturesRef[i] = 0;
                _textures[i] = 0;
            }
        }
        
        if (pixelBufTexture.CVTextureCacheRef) {
            CVOpenGLESTextureCacheFlush(_textureCache, 0);
        }
        
        if (_textures[0]) {
            glDeleteTextures(2, _textures);
        }
        
        size_t frameWidth  = pixelBufTexture.width;
        size_t frameHeight = pixelBufTexture.height;
        
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                     _textureCache,
                                                     pixelBufTexture.CVTextureCacheRef,
                                                     NULL,
                                                     GL_TEXTURE_2D,
                                                     GL_RED_EXT,
                                                     (GLsizei)frameWidth,
                                                     (GLsizei)frameHeight,
                                                     GL_RED_EXT,
                                                     GL_UNSIGNED_BYTE,
                                                     0,
                                                     &_cvTexturesRef[0]);
        _textures[0] = CVOpenGLESTextureGetName(_cvTexturesRef[0]);
        glBindTexture(CVOpenGLESTextureGetTarget(_cvTexturesRef[0]), _textures[0]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                     _textureCache,
                                                     pixelBufTexture.CVTextureCacheRef,
                                                     NULL,
                                                     GL_TEXTURE_2D,
                                                     GL_RG_EXT,
                                                     (GLsizei)frameWidth / 2,
                                                     (GLsizei)frameHeight / 2,
                                                     GL_RG_EXT,
                                                     GL_UNSIGNED_BYTE,
                                                     1,
                                                     &_cvTexturesRef[1]);
        _textures[1] = CVOpenGLESTextureGetName(_cvTexturesRef[1]);
        glBindTexture(CVOpenGLESTextureGetTarget(_cvTexturesRef[1]), _textures[1]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
}

- (void)prepareRender
{
//    [self userCurrentContext];
//    [self userCurrentGLProgram];
    
    glUniform1i(_yuvTypeUniform, self.yuvTypeValue);
    
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "texcoord"));
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glVertexAttribPointer(glGetAttribLocation(self.glProgram, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.glProgram, "position"));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textures[0]);
    glUniform1i(_samplerYUniform, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _textures[1]);
    glUniform1i(_samplerUVUniform, 1);
    
    glUniformMatrix3fv(_rotateXMatrixUniform, 1, 0, _xRotateMatrix);
    glUniformMatrix3fv(_rotateYMatrixUniform, 1, 0, _yRotateMatrix);
    glUniformMatrix3fv(_rotateZMatrixUniform, 1, 0, _zRotateMatrix);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glDrawElements(GL_TRIANGLE_STRIP, _indexCount, GL_UNSIGNED_BYTE, 0);
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupGLProgram
{
    [super setupGLProgram];
    _samplerYUniform = glGetUniformLocation(self.glProgram, "samplerY");
    _samplerUVUniform = glGetUniformLocation(self.glProgram, "samplerUV");
}

-(void)clearRenderBuffer
{
    [super clearRenderBuffer];
    for (int i = 0; i < 2; ++i) {
        if (_cvTexturesRef[i]) {
            CFRelease(_cvTexturesRef[i]);
            _cvTexturesRef[i] = 0;
            _textures[i] = 0;
        }
    }
        
    if (_textures[0]) {
        glDeleteTextures(2, _textures);
    }
}
@end

