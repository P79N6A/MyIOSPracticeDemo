
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "GLiveGLShareInstance"
#pragma clang diagnostic pop

#import "GLiveGLShareInstance.h"

@implementation GLiveGLShareInstance


+ (GLiveGLShareInstance *)shareInstance
{
    static GLiveGLShareInstance *g_sharedOpenGLInstance = nil;
    static dispatch_once_t g_shareOpenglOnce;
    dispatch_once(&g_shareOpenglOnce, ^{
        g_sharedOpenGLInstance = [GLiveGLShareInstance new];
    });
    return g_sharedOpenGLInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _cellLayoutQueue = dispatch_queue_create("OpenCameraGLDemo", DISPATCH_QUEUE_SERIAL);
//        _isInit = NO;
//        _vetexBuffer = -1;
//        _indexBuffer = -1;
    }
    return self;
}
//- (BOOL)initOpenGL
//{
//
//    if (_isInit == NO)
//    {
//        QLog_Event(MODULE_IMP_AV_OPENGL, "initOpenGL SUCESS....");
//
//        [self setuploadingImage];
//        [self setupContext];
//        [self compileShaders];
//        [self setupIndices];
//        [self setupVBO];
//
//        _isInit=YES;
//        return YES;
//    }
//    else
//    {
//        QLog_Event(MODULE_IMP_AV_OPENGL, "initOpenGL FAIL!!! instance existed");
//        return NO;
//    }
//}
//
//- (void)setuploadingImage
//{
//    UIImage * loadImage = [g_var_VideoNeedInfo   getImage:@"AV_Loading.png"];
//
//    AVGLImage * image = [AVGLImage new];
//    image.width = loadImage.size.width;
//    image.height = loadImage.size.height;
//    image.data = [AVGLImage getImageData:loadImage];
//    image.isFullScreenShow = YES;
//    image.angle = 0;
//    self.loadingImage = image;
//    CZ_RELEASE(image);
//}
//
//- (void)useCurrentProgram
//{
//    glUseProgram(_programHandle);
//}
//- (AVContext *)getContext
//{
//    return _context;
//}
//- (void)useCurrentContext
//{
//    if (_context && ![EAGLContext setCurrentContext:_context]) {
//        QLog_Event(MODULE_IMP_AV_OPENGL, "Failed to set current OpenGL context");
//        exit(1);
//    }
//}
//
//- (void)setupContext{
//    if(CZ_GetSharedUIApplication().applicationState !=UIApplicationStateActive){
//        QLog_Event(MODULE_IMP_AV_OPENGL, "background setupContext:%d",CZ_GetSharedUIApplication().applicationState);
//    }
//
//    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
//    _context = [[AVContext alloc] initWithAPI:api];
//
//    if (!_context) {
//        NSLog(@"Failed to initialize OpenGLES 2.0 context");
//        exit(1);
//    }
//
//    if (![EAGLContext setCurrentContext:_context]) {
//        NSLog(@"Failed to set current OpenGL context");
//        exit(1);
//    }
//}
//
////顶点缓冲区初始化
//- (void)setupVBO
//{
//    glGenBuffers(1, &_vetexBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, _vetexBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(initVertices), initVertices, GL_DYNAMIC_DRAW);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
//}
//
////索引缓冲区初始化
//- (void)setupIndices {
//    glGenBuffers(1, &_indexBuffer);
//
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//}
//
//- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
//
//    NSError* error = nil;
//
//    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
//                                                           ofType:@"glsl"];
//    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
//                                                       encoding:NSUTF8StringEncoding error:&error];
//    if (!shaderString) {
//        NSLog(@"Error loading shader: %@", error.localizedDescription);
//        exit(1);
//    }
//
//    // 2
//    GLuint shaderHandle = glCreateShader(shaderType);
//
//    // 3
//    const char* shaderStringUTF8 = [shaderString UTF8String];
//
//    int shaderStringLength = (int)[shaderString length];
//
//    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
//
//    // 4
//    glCompileShader(shaderHandle);
//
//    // 5
//    GLint compileSuccess;
//    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
//    if (compileSuccess == GL_FALSE) {
//        GLchar messages[256];
//        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
//        NSString *messageString = [NSString stringWithUTF8String:messages];
//        NSLog(@"%@", messageString);
//        exit(1);
//    }
//
//    return shaderHandle;
//
//}
//
//- (void)destroyOpenGL
//{
//    if (_textureUniforms) {
//        free(_textureUniforms);
//        _textureUniforms = nil;
//    }
//
//    if (_textureRGB) {
//        _textureRGB = 0;
//    }
//
//    //Ëø????context = nil‰º??crash???Ëø??Ôº???∞Ê?‰∫???πÁ?demo‰ª£Á????Ê≤°Ê?Ëø???•Ô???ª•?ªÊ?Ëø????//    _context = nil;
//
//    QLog_Event(MODULE_IMP_AV_OPENGL, "destroyOpenGL:vertex:%d,index:%d",_vetexBuffer,_indexBuffer);
//
//    glUseProgram(0);
//    glDetachShader(_programHandle, _vertexShaderHandle);
//    glDetachShader(_programHandle, _fragmentShaderHandle);
//
//    glDeleteShader(_vertexShaderHandle);
//    glDeleteShader(_fragmentShaderHandle);
//    glDeleteProgram(_programHandle);
//
//    glBindTexture(GL_TEXTURE_2D, 0);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//    if (_vetexBuffer != -1) {
//        glDeleteBuffers(1, &_vetexBuffer);
//        _vetexBuffer = 0;
//    }
//    if (_indexBuffer != -1) {
//        glDeleteBuffers(1, &_indexBuffer);
//        _indexBuffer = 0;
//    }
//
//    if ([EAGLContext currentContext] == _context) {
//        [EAGLContext setCurrentContext:nil];
//    }
//    if (_context) {
//        CZ_RELEASE(_context);
//        _context = nil;
//    }
//
//    _isInit = NO;
//}
//
//- (void)compileShaders {
//
//    _vertexShaderHandle = [self compileShader:@"Shaderv"
//                                     withType:GL_VERTEX_SHADER];
//    _fragmentShaderHandle = [self compileShader:@"Shaderf"
//                                       withType:GL_FRAGMENT_SHADER];
//
//    // 2
//    _programHandle = glCreateProgram();
//    glAttachShader(_programHandle, _vertexShaderHandle);
//    glAttachShader(_programHandle, _fragmentShaderHandle);
//    glLinkProgram(_programHandle);
//
//    // 3
//    GLint linkSuccess;
//    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
//    if (linkSuccess == GL_FALSE) {
//        GLchar messages[256];
//        glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
//        NSString *messageString = [NSString stringWithUTF8String:messages];
//        NSLog(@"%@", messageString);
//        exit(1);
//    }
//
//    // 4
//    glUseProgram(_programHandle);
//
//    // 5
//    _positionAttributeLocation = glGetAttribLocation(_programHandle, "position");
//
//    _texCoordAttributeLocation = glGetAttribLocation(_programHandle, "textureCoordinate");
//
//    _textureUniforms = (GLuint *)malloc(4*sizeof(GLuint));
//
//    _rotateXMatrixUniform = glGetUniformLocation(_programHandle, "rotateXMatrix");
//    _rotateYMatrixUniform = glGetUniformLocation(_programHandle, "rotateYMatrix");
//    _rotateZMatrixUniform = glGetUniformLocation(_programHandle, "rotateZMatrix");
//
//    _textureUniforms[0] = glGetUniformLocation(_programHandle, "SamplerY");
//    _textureUniforms[1] = glGetUniformLocation(_programHandle, "SamplerU");
//    _textureUniforms[2] = glGetUniformLocation(_programHandle, "SamplerV");
//    _textureUniforms[3] = glGetUniformLocation(_programHandle, "SamplerA");
//    _textureRGB = glGetUniformLocation(_programHandle, "SamplerRGB");
//
//    _boundsUniform = glGetUniformLocation(_programHandle, "layerBoundsWidth");
//
//    _drawTypeUniform = glGetUniformLocation(_programHandle, "drawType");
//
//    _vertexDrawTypeUniform = glGetUniformLocation(_programHandle, "vertexDrawType");
//
//    _displayType = glGetUniformLocation(_programHandle, "displayType");
//
//    _yuvTypeUniform = glGetUniformLocation(_programHandle, "yuvType");
//
//    _textureRotateUinform = glGetUniformLocation(_programHandle, "textureRotateMatrix");
//
//    _textureScaleUniform = glGetUniformLocation(_programHandle, "textureScaleMatrix");
//
//    _textureBoundsUniform = glGetUniformLocation(_programHandle, "textureBoundsMatrix");
//
//    _resolutionUniform = glGetUniformLocation(_programHandle, "resolution");
//    _originCoordUniform = glGetUniformLocation(_programHandle, "originCoord");
//    _radiusCoordUniform = glGetUniformLocation(_programHandle, "radius");
//
//    _distortRange = glGetUniformLocation(_programHandle, "range");
//    _stride_x = glGetUniformLocation(_programHandle, "stride_x");
//    _stride_y = glGetUniformLocation(_programHandle, "stride_y");
//    _distortType = glGetUniformLocation(_programHandle, "distortType");//0 凸出，1 凹陷
//    _distortOri = glGetUniformLocation(_programHandle, "distortOri");//0 向左，1 向右
//    _angle = glGetUniformLocation(_programHandle, "angle");
//}

@end
