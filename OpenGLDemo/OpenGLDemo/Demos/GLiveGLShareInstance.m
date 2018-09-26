
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "GLiveGLShareInstance"
#pragma clang diagnostic pop

#import "GLiveGLShareInstance.h"
#import <UIKit/UIKit.h>

#define SYSTEMVERSION(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

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
        
        dispatch_queue_attr_t attr = NULL;
        if (SYSTEMVERSION(@"8.0")) {
            attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
                                                           QOS_CLASS_USER_INTERACTIVE,
                                                           DISPATCH_QUEUE_PRIORITY_HIGH);
        }
        _cellLayoutQueue = dispatch_queue_create("GLiveGLRenderQueue", attr);
        dispatch_queue_set_specific(_cellLayoutQueue,
                                    &_g_ijk_gles_queue_spec_key,
                                    &_g_ijk_gles_queue_spec_key,
                                    NULL);
        
    }
    return self;
}
@end
