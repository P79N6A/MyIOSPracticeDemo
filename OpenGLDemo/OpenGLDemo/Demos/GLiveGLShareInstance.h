

#import <Foundation/Foundation.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface GLiveGLShareInstance : NSObject
{
}

@property (nonatomic,retain) dispatch_queue_t cellLayoutQueue;
@property (nonatomic,assign) int g_ijk_gles_queue_spec_key;

+(GLiveGLShareInstance *)shareInstance;
//- (BOOL)initOpenGL;
//- (void)destroyOpenGL;
//- (void)useCurrentContext;
//- (void)useCurrentProgram;
//- (AVContext *)getContext;

@end

