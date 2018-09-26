//
//  AVGLShareInstance.h
//  OpenGLRestruct
//
//  Created by vigoss on 14-11-11.
//  Copyright (c) 2014年 vigoss. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//@interface AVContext:EAGLContext
//@end
//
//@class AVGLImage;
@interface GLiveGLShareInstance : NSObject
{
}

@property (nonatomic,retain) dispatch_queue_t cellLayoutQueue;

+(GLiveGLShareInstance *)shareInstance;
//- (BOOL)initOpenGL;
//- (void)destroyOpenGL;
//- (void)useCurrentContext;
//- (void)useCurrentProgram;
//- (AVContext *)getContext;

@end
