//
//  DrawableVBOFactory.h
//
//  Created by kesalin@gmail.com kesalin on 12-12-30.
//  Copyright (c) 2012年 http://blog.csdn.net/kesalin/. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>

@interface DrawableVBO : NSObject

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint lineIndexBuffer;
@property (nonatomic, assign) GLuint triangleIndexBuffer;
@property (nonatomic, assign) int vertexSize;
@property (nonatomic, assign) int lineIndexCount;
@property (nonatomic, assign) int triangleIndexCount;

- (void) cleanup;

@end

//
// Surface Type enum
//
enum SurfaceType {
    SurfaceCube,
    SurfaceSphere,
    SurfaceTorus,
    SurfaceTrefoilKnot,
    SurfaceKleinBottle,
    SurfaceMobiusStrip
};
typedef enum SurfaceType SurfaceType;

//
// DrawableVBOFactory interface
//
@interface DrawableVBOFactory : NSObject

// Create drawable VBO with normal and texture coord.
//
+ (DrawableVBO *) createDrawableVBO:(SurfaceType) type;

@end
