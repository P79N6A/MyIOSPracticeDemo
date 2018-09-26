#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GLTexture : NSObject
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@end

@interface GLTextureRGB : GLTexture
@property (nonatomic, assign) uint8_t *RGBA;
@end

@interface GLTextureYUV : GLTexture
@property (nonatomic, assign) uint8_t *Y;
@property (nonatomic, assign) uint8_t *U;
@property (nonatomic, assign) uint8_t *V;

- (instancetype)initWithSize:(CGSize)szTexture;
@end

@interface GLTexturePixelBuffer : GLTexture
-(id)initWithTextureCache:(CVPixelBufferRef) textureCache;
@property (nonatomic, assign)CVPixelBufferRef CVTextureCacheRef;
- (void)deleteTexture;
@end
