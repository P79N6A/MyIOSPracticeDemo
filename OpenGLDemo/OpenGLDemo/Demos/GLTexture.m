#import "GLTexture.h"
#import "GLiveMiniMempool.h"
@implementation GLTexture
@end

@implementation GLTextureRGB
- (void)dealloc
{
    if (_RGBA) {
        free(_RGBA);
        _RGBA = NULL;
    }
}
@end

@implementation GLTextureYUV
{
    size_t _szYPlane;
    size_t _szUPlane;
    size_t _szVPlane;
}

- (instancetype)initWithSize:(CGSize)szTexture
{
    if (self = [super init]) {
        self.width = szTexture.width;
        self.height = szTexture.height;
        _szYPlane = szTexture.width * szTexture.height;
        _szUPlane = _szYPlane/4;
        _szVPlane = _szYPlane/4;
        _Y = [[GLiveMiniMempool shareInstance] mallocSpaceWithSize:_szYPlane];
        _U = [[GLiveMiniMempool shareInstance] mallocSpaceWithSize:_szUPlane];
        _V = [[GLiveMiniMempool shareInstance] mallocSpaceWithSize:_szVPlane];
    }
    return self;
}

- (void)dealloc
{
    if (_szYPlane != 0) {
        [[GLiveMiniMempool shareInstance] freeSpaceWithSize:_szYPlane memPtr: _Y];
    }
    
    if (_szUPlane != 0) {
        [[GLiveMiniMempool shareInstance] freeSpaceWithSize:_szUPlane memPtr: _U];
    }
    
    if (_szVPlane != 0) {
        [[GLiveMiniMempool shareInstance] freeSpaceWithSize:_szVPlane memPtr: _V];
    }
}
@end

@implementation GLTexturePixelBuffer

-(id)initWithTextureCache:(CVPixelBufferRef) pixelBuffer
{
    if (self = [super init]) {
        self.width  = (int)CVPixelBufferGetWidth(pixelBuffer);
        self.height = (int)CVPixelBufferGetHeight(pixelBuffer);
        _CVTextureCacheRef =  pixelBuffer;
    }
    
    return self;
    
}

- (void)deleteTexture
{
    CFRelease(_CVTextureCacheRef);
}

- (void)dealloc
{
    [self deleteTexture];
}

@end
