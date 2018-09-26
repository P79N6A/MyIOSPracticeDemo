//  Created by applechang on 2017-5-10.
//  Copyright (c) 2017年 TENCENT. All rights reserved.

#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLiveGLUtil.h"
#import "GLiveAVExternalEnum.h"

@interface GLiveGLRender : NSObject
{
    float      _xRotateMatrix[9];
    float      _yRotateMatrix[9];
    float      _zRotateMatrix[9];
    GLuint     _rotateXMatrixUniform;
    GLuint     _rotateYMatrixUniform;
    GLuint     _rotateZMatrixUniform;
    GLuint     _vertexVBO;
    GLuint     _textureVBO;
    GLuint     _indexVBO;
    GLuint     _indexCount;
    NSMutableArray* _renderFrameBuffer;
    GLTexture*      _curRenderTexture;
    CGPoint      _texTopLeft;
    CGPoint      _texBottomLeft;
    CGPoint      _texTopRight;
    CGPoint      _texBottomRight;
    GLuint       _yuvTypeUniform;
}

@property (nonatomic,retain) EAGLContext* context;
@property (nonatomic,assign) GLuint glProgram;
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) int yuvTypeValue;

- (instancetype)initWithSize:(CGSize)texSize;
- (void)prepareRender;
- (void)setTexture:(GLTexture *)texture;
- (void)drawTexture:(GLTexture *)texture viewX:(GLint)x viewY:(GLint)y viewWidth:(GLsizei)width viewHeight:(GLsizei)height;
- (void)setRotationWithDegree:(float)degrees
                      withAxis:(GLIVE_VIDEO_ROTATE_AXIS)axis
                      withType:(GLIVE_VIDEO_ROTATE_TYPE)rotateType;
- (void)clearRenderBuffer;
- (void)userCurrentGLProgram;
- (void)userCurrentContext;
@end

@interface GLiveGLRenderRGB : GLiveGLRender
{
    GLuint _rgbTexture;
    GLuint _rgbUniform;
}
@end

@interface GLiveGLRenderYUV : GLiveGLRender
{
    GLuint _yPlaneTexture;
    GLuint _uPlaneTexture;
    GLuint _vPlaneTexture;
    GLuint _yPlaneUniform;
    GLuint _uPlaneUniform;
    GLuint _vPlaneUniform;
}
@end

@interface GLiveGLRenderPixelBuffer : GLiveGLRender
{
    GLuint _samplerYUniform;
    GLuint _samplerUVUniform;
    
    CVOpenGLESTextureCacheRef _textureCache;
    GLuint _textures[2];
    
    CVOpenGLESTextureRef      _cvTexturesRef[2];
}
- (void)setTexture:(GLTexture *)texture;
- (instancetype)initWithSize:(CGSize)texSize withContext:(EAGLContext*) context;
@end
