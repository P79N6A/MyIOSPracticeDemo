

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#define FCC__VTB 1

#define IJK_STRINGIZE(x) #x
#define IJK_STRINGIZE2(x) IJK_STRINGIZE(x)
#define IJK_SHADER_STRING(text) @ IJK_STRINGIZE2(text)

@protocol IJKSDLGLRender
- (BOOL) isValid;
- (NSString *) fragmentShader;
- (void) resolveUniforms: (GLuint) program;
- (void) render: (void *) overlay;
- (BOOL) prepareDisplay;
@end

// BT.709, which is the standard for HDTV.
static const GLfloat kColorConversion709[] = {
    1.164,  1.164,  1.164,
    0.0,   -0.213,  2.112,
    1.793, -0.533,  0.0,
};

// BT.601, which is the standard for SDTV.
static const GLfloat kColorConversion601[] = {
    1.164,  1.164, 1.164,
    0.0,   -0.392, 2.017,
    1.596, -0.813,   0.0,
};

static const GLfloat kColorConversionQQ[] = {
    1.0,  1.0, 1.0,
    0.0,   -0.344, 1.772,
    1.402, -0.714,   0.0,
};
