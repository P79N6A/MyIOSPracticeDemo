//
//  GLRGBRender.h
//  OpenGLES11-相机视频渲染
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 Qinmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLUtil.h"

@interface GLRender : NSObject
{
    GLuint     _vertexVBO;
    GLuint     _textureVBO;
    GLuint     _indexVBO;
    GLuint     _rotateXMatrixUniform;
    GLuint     _rotateYMatrixUniform;
    GLuint     _rotateZMatrixUniform;
    float      _xRotateMatrix[9];
    float      _yRotateMatrix[9];
    float      _zRotateMatrix[9];
}

@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) GLuint vertexVBO;
@property (nonatomic, assign) int vertCount;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property(nonatomic, assign) GLuint rotateXMatrixUniform;
@property(nonatomic, assign) GLuint rotateYMatrixUniform;
@property(nonatomic, assign) GLuint rotateZMatrixUniform;

- (void)setTexture:(GLTexture *)texture;
- (void)prepareRender;
@end

@interface GLRenderRGB : GLRender
@property(nonatomic, assign, readonly) GLuint rgb;
@end

@interface GLRenderYUV : GLRender
{
    GLuint _yPlaneTexture;
    GLuint _uPlaneTexture;
    GLuint _vPlaneTexture;
    GLuint _yPlaneUniform;
    GLuint _uPlaneUniform;
    GLuint _vPlaneUniform;
}

@property(nonatomic, assign, readonly) GLuint y;
@property(nonatomic, assign, readonly) GLuint u;
@property(nonatomic, assign, readonly) GLuint v;
- (instancetype)initWithSize:(CGSize)texSize;
@end
