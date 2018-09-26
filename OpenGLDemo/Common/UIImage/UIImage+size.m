
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIImage+size"
#pragma clang diagnostic pop

//
//  UIImage+size.m
//  QZone
//
//  Created by timmzhang on 12-12-20.
//
//
#import "UIImage+size.h"

@implementation UIImage (size)

/*真实大小*/
- (CGSize)realSize
{
    return CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
}

/*绘制大小（根据retina屏幕计算出正确的绘制大小）*/
- (CGSize)drawSize
{
    return [self drawSizeWithScale:[UIScreen mainScreen].scale];
}

- (CGSize)drawSizeWithScale:(CGFloat)scale{
    
    CGSize originalSize = [self realSize];
    if (scale == 0) {
        return originalSize;
    }
    // 真实的图片会出现奇数，在裁剪的时候会导致跟计算的区域不同，这里直接舍掉小数后的值。 modify by watering 2015-05-25
    CGFloat width = MAX(1, floorf(originalSize.width / scale));
    CGFloat height = MAX(1, floorf(originalSize.height / scale));
    return CGSizeMake(width, height);
}

//用矩形框裁剪图片
- (UIImage *)clipByRect:(CGRect)rect
{
    return [self clipByRect:rect scale:1];
}

//用矩形框裁剪图片
- (UIImage *)clipByRect:(CGRect)rect scale:(CGFloat)scale
{
    //得到物理分辨率
    CGSize imageSize = self.size;
    imageSize.width = imageSize.width * self.scale;
    imageSize.height = imageSize.height * self.scale;
    
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    //计算相交区域
    CGRect shareRect = CGRectIntersection(imageRect, rect);
    if (CGRectIsEmpty(shareRect)) {
        return nil;
    }
    
    CGImageRef dstImageRef = CGImageCreateWithImageInRect(self.CGImage, shareRect);
    UIImage *dstImage = [UIImage imageWithCGImage:dstImageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(dstImageRef);
    return dstImage;
}

+ (UIImage *)resizeImage:(UIImage *)image withNewSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)makeRoundCornerImage:(UIImage*)img :(NSInteger)cornerWidth :(NSInteger)cornerHeight
{
    //return img ;
    
    UIImage * newImage = nil;
    
    if( nil != img)
    {
        int w = img.size.width;
        int h = img.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        dlAddRoundedRectToPath2(context,rect,MIN(cornerWidth,cornerHeight));
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [UIImage imageWithCGImage:imageMasked] ;
        CGImageRelease(imageMasked);
    }
    
    return newImage;
    
}

static void dlAddRoundedRectToPath2(CGContextRef context, CGRect rect ,float radius)
{
    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    float width = CGRectGetWidth (rect);
    float height = CGRectGetHeight (rect);
    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    CGContextRestoreGState(context);
}

- (UIImage *)scaleToSizeByAspectMax:(CGFloat)targetSize {
    CGFloat scaleWidth = self.size.width;
    CGFloat scaleHeight = self.size.height;
    
    if (self.size.width > targetSize || self.size.height > targetSize) {
        CGFloat scaleFactor = 0.0;
        CGFloat widthFactor = targetSize / self.size.width;
        CGFloat heightFactor = targetSize / self.size.height;
        
        //取小的比率值
        scaleFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor;
        
        //四舍五入取整
        scaleWidth  = round(scaleFactor * self.size.width);
        scaleHeight = round(scaleFactor * self.size.height);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight));
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
