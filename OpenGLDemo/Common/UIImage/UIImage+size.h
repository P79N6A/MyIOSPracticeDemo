//
//  UIImage+size.h
//  QZone
//
//  Created by timmzhang on 12-12-20.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (size)

/*真实大小*/
- (CGSize)realSize;

/*绘制大小（根据retina屏幕计算出正确的绘制大小）*/
- (CGSize)drawSize;

/*绘制大小（根据scale计算出正确的绘制大小）*/
- (CGSize)drawSizeWithScale:(CGFloat)scale;

//用矩形框裁剪图片,
//注意rect为分辨率,不是logical size
- (UIImage *)clipByRect:(CGRect)rect;
- (UIImage *)clipByRect:(CGRect)rect scale:(CGFloat)scale;

+ (UIImage *)resizeImage:(UIImage *)image withNewSize:(CGSize)newSize;

//圆角图片
+ (UIImage *)makeRoundCornerImage:(UIImage*)img :(NSInteger)cornerWidth :(NSInteger)cornerHeight;

- (UIImage *)scaleToSizeByAspectMax:(CGFloat)targetSize;
@end
