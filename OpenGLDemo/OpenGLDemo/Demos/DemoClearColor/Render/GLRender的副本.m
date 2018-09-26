//
//  GLRGBRender.m
//  OpenGLES11-相机视频渲染
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 Qinmin. All rights reserved.
//

#import "GLRender.h"

typedef enum eGLiveVideoRotateAxis
{
    Rotation_Axis_X,
    Rotation_Axis_Y,
    Rotation_Axis_Z,
    
}GLIVE_VIDEO_ROTATE_AXIS;

typedef enum eGLiveVideoRotateType
{
    Rotation_Type_Vertex,
    Rotation_Type_Texture,
    
}GLIVE_VIDEO_ROTATE_TYPE;

////////////////GLRender//////////////////////////
@implementation GLRender
- (void)setupGLProgram
{
}

- (void)setTexture:(GLTexture *)texture
{
}

- (void)prepareRender
{
}
@end

////////////////GLRenderRGB//////////////////////////
@implementation GLRenderRGB

- (instancetype)init
{
    if (self = [super init]) {
        [self setupGLProgram];
        [self setupVBO];
        
        // 这里宽高设置死了，但是可以动态设置
        _rgb = createTexture2D(GL_RGBA, 640, 480, NULL);
    }
    return self;
}

- (void)setupGLProgram
{
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag_rgb.glsl" ofType:nil];
    
    self.program = createGLProgramFromFile(vertFile.UTF8String, fragFile.UTF8String);
    glUseProgram(self.program);
    //self.rotateXMatrixUniform = glGetUniformLocation(self.program, "rotateXMatrix");
    self.rotateYMatrixUniform = glGetUniformLocation(self.program, "rotateYMatrix");
    self.rotateZMatrixUniform = glGetUniformLocation(self.program, "rotateZMatrix");
}

- (void)setupVBO
{
    self.vertCount = 6;
    
    GLfloat vertices[] = {
        0.8f,  0.6f, 0.0f, 1.0f, 0.0f,   // 右上
        0.8f, -0.6f, 0.0f, 1.0f, 1.0f,   // 右下
        -0.8f, -0.6f, 0.0f, 0.0f, 1.0f,  // 左下
        -0.8f, -0.6f, 0.0f, 0.0f, 1.0f,  // 左下
        -0.8f,  0.6f, 0.0f, 0.0f, 0.0f,  // 左上
        0.8f,  0.6f, 0.0f, 1.0f, 0.0f,   // 右上
    };
    
    // 创建VBO
    self.vertexVBO = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
}

- (void)setTexture:(GLTexture *)texture
{
    if ([texture isMemberOfClass:[GLTextureRGB class]]) {
        
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        GLTextureRGB *rgbTexture = (GLTextureRGB *)texture;
        glBindTexture(GL_TEXTURE_2D, _rgb);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width, texture.height, GL_RGBA, GL_UNSIGNED_BYTE, rgbTexture.RGBA);
    }
}

- (void)prepareRender
{
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexVBO);
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "position"));
    glVertexAttribPointer(glGetAttribLocation(self.program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(self.program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _rgb);
    glUniform1i(glGetUniformLocation(self.program, "image0"), 0);
    
    glDrawArrays(GL_TRIANGLES, 0, self.vertCount);
}

@end

////////////////GLRenderYUV//////////////////////////
@implementation GLRenderYUV
- (instancetype)initWithSize:(CGSize)texSize
{
    if (self = [super init]) {
        [self setupGLProgram];
        [self setupVBO];
        
        self.height = texSize.height;
        self.width = texSize.width;
        _y = createTexture2D(GL_LUMINANCE, texSize.width, texSize.height, NULL);
        _u = createTexture2D(GL_LUMINANCE, texSize.width/2, texSize.height/2, NULL);
        _v = createTexture2D(GL_LUMINANCE, texSize.width/2, texSize.height/2, NULL);
    }
    return self;
}

- (void)setupGLProgram
{
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag.glsl" ofType:nil];
    
    self.program = createGLProgramFromFile(vertFile.UTF8String, fragFile.UTF8String);
    glUseProgram(self.program);
    
    self.rotateXMatrixUniform = glGetUniformLocation(self.program, "rotateXMatrix");
    self.rotateYMatrixUniform = glGetUniformLocation(self.program, "rotateYMatrix");
    self.rotateZMatrixUniform = glGetUniformLocation(self.program, "rotateZMatrix");
}

- (void)setupVBO
{
    self.vertCount = 6;
    
    GLfloat vertices[] = {
        1.0f,  1.0f, 0.0f, 1.0f, 0.0f,   // 右上
        1.0f, -1.0f, 0.0f, 1.0f, 1.0f,   // 右下
        -1.0f, -1.0f, 0.0f, 0.0f, 1.0f,  // 左下
        -1.0f, -1.0f, 0.0f, 0.0f, 1.0f,  // 左下
        -1.0f,  1.0f, 0.0f, 0.0f, 0.0f,  // 左上
        1.0f,  1.0f, 0.0f, 1.0f, 0.0f,   // 右上
    };
    
    // 创建VBO
    self.vertexVBO = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
}

- (void)setupVBOEX
{
    const GLfloat texCoords[] = {
        1.0f, 0.0f, //右上
        1.0f, 1.0f, //右下
        0.0f, 1.0f, //左下
        0.0f, 0.0f, //左上
    };
    
    glGenBuffers(1, &_textureVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(texCoords), texCoords, GL_DYNAMIC_DRAW);
    
    
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
        2,3,1
    };
    
    glGenBuffers(1, &_indexVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_DYNAMIC_DRAW);
}

- (void)setTexture:(GLTexture *)texture
{
    if ([texture isMemberOfClass:[GLTextureYUV class]]) {
        GLTextureYUV *rgbTexture = (GLTextureYUV *)texture;
        
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        glBindTexture(GL_TEXTURE_2D, _y);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width, texture.height, GL_LUMINANCE, GL_UNSIGNED_BYTE, rgbTexture.Y);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_2D, _u);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width/2, texture.height/2, GL_LUMINANCE, GL_UNSIGNED_BYTE, rgbTexture.U);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        glBindTexture(GL_TEXTURE_2D, _v);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width/2, texture.height/2, GL_LUMINANCE, GL_UNSIGNED_BYTE, rgbTexture.V);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
}

- (void)prepareRender
{
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexVBO);
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "position"));
    glVertexAttribPointer(glGetAttribLocation(self.program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(self.program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _y);
    glUniform1i(glGetUniformLocation(self.program, "image0"), 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _u);
    glUniform1i(glGetUniformLocation(self.program, "image1"), 1);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _v);
    glUniform1i(glGetUniformLocation(self.program, "image2"), 2);
    
    
    [self applyRotationWithDegree:-90 withAxis:Rotation_Axis_Z withType:Rotation_Type_Vertex];
    [self applyRotationWithDegree:0 withAxis:Rotation_Axis_X withType:Rotation_Type_Vertex];
    [self applyRotationWithDegree:180 withAxis:Rotation_Axis_Y withType:Rotation_Type_Vertex];
    glDrawArrays(GL_TRIANGLES, 0, self.vertCount);
}

//- (void)prepareRenderHuayangDemo
//{
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
//    glEnableVertexAttribArray(glGetAttribLocation(_program, "position"));
//    glVertexAttribPointer(glGetAttribLocation(_program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
//
//    glEnableVertexAttribArray(glGetAttribLocation(_program, "texcoord"));
//    glVertexAttribPointer(glGetAttribLocation(_program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
//
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, _yPlaneTexture);
//    glUniform1i(_yPlaneUniform, 0);
//
//    glActiveTexture(GL_TEXTURE1);
//    glBindTexture(GL_TEXTURE_2D, _uPlaneTexture);
//    glUniform1i(_uPlaneUniform, 1);
//
//    glActiveTexture(GL_TEXTURE2);
//    glBindTexture(GL_TEXTURE_2D, _vPlaneTexture);
//    glUniform1i(_vPlaneUniform, 2);
//
//
//    glUniformMatrix3fv(_rotateXMatrixUniform, 1, 0, _xRotateMatrix);
//    glUniformMatrix3fv(_rotateYMatrixUniform, 1, 0, _yRotateMatrix);
//    glUniformMatrix3fv(_rotateZMatrixUniform, 1, 0, _zRotateMatrix);
//
//    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
//}

- (void) prepareRenderWithIndexVBO{
    
    glBindBuffer(GL_ARRAY_BUFFER, _textureVBO);
    glVertexAttribPointer(glGetAttribLocation(self.program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "texcoord"));
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexVBO);
    glVertexAttribPointer(glGetAttribLocation(self.program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    glEnableVertexAttribArray(glGetAttribLocation(self.program, "position"));
    
    const GLubyte indices[] = {
        0,1,2,
        2,3,0
    };
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
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
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
}


- (void) applyRotationWithDegree:(float)degrees withAxis:(GLIVE_VIDEO_ROTATE_AXIS)axis withType:(GLIVE_VIDEO_ROTATE_TYPE)rotateType
{
    float radians = degrees * 3.14159f / 180.0f;
    float s = sin(radians);
    float c = cos(radians);

    switch (axis) {
        case Rotation_Axis_X:
        {
            float xRotation[9] = {
                1.0, 0.0, 0.0,
                0.0, c, s,
                0.0, -s, c
            };
            
            glUniformMatrix3fv(self.rotateXMatrixUniform , 1, 0, &xRotation[0]);
        }
        break;
        case Rotation_Axis_Y:
        {
            float yRotation[9] = {
                c, 0.0, -s,
                0.0, 1.0, 0.0,
                -s, 0.0, c,
            };
            
            glUniformMatrix3fv(self.rotateYMatrixUniform , 1, 0, &yRotation[0]);
        }
        break;
        case Rotation_Axis_Z:
        {
            float zRotation[9] ={
                    c, s, 0.0,
                    -s, c, 0.0,
                    0.0, 0.0, 1.0
                };
            glUniformMatrix3fv(self.rotateZMatrixUniform , 1, 0, &zRotation[0]);
        }
        break;
        default:
        break;
    }
}
@end
