//
//  PLCropView.m
//  HuaYang
//
//  Created by zekaizhang on 16/7/5.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PLCropView.h"

static const CGFloat AvatarMarginTop = 39.5;
static const CGFloat AvatarMarginLeft = 0;

@interface PLCropView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_zoomingView;
    UIImageView *_imageView;
    UIView *_cropRectView;
    UIView *_topOverlayView;
    UIView *_leftOverlayView;
    UIView *_rightOverlayView;
    UIView *_bottomOverlayView;
    CGRect _insetRect;
    CGRect _editingRect;
    UIInterfaceOrientation _interfaceOrientation;
}
@end

@implementation PLCropView
//@dynamic image;
//@dynamic croppedImage;
//@dynamic isShowAvatarPendant;
//@dynamic aspectRatio;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        _scrollView.maximumZoomScale = 20.0f;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //_scrollView.bounces = NO;
        //_scrollView.bouncesZoom = NO;
        _scrollView.clipsToBounds = NO;
        [self addSubview:_scrollView];
        
        _cropRectView = [[UIView alloc] init];
        [_cropRectView setBackgroundColor:[UIColor clearColor]];
        _cropRectView.contentMode = UIViewContentModeRedraw;
        _cropRectView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropRectView.layer.borderWidth = 1;
        [self addSubview:_cropRectView];
    }
    return self;
}

- (void)setIsShowAvatarPendant:(BOOL)isShowAvatarPendant{
    _isShowAvatarPendant = isShowAvatarPendant;
    [self resetLayout];
}

- (void)addAvatarPendantView{
    //    [self addCircleMask];
}

- (void)addCircleMask{
    _cropRectView.layer.borderColor = [UIColor whiteColor].CGColor;
    _cropRectView.layer.borderWidth = 0;
    
    int radius = _cropRectView.frame.size.width/2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:0];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_cropRectView.frame.origin.x, _cropRectView.frame.origin.y, 2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.path = path.CGPath;
    circleMaskLayer.fillRule = kCAFillRuleEvenOdd;
    circleMaskLayer.fillColor = [UIColor colorWithWhite:0.0f alpha:0.4f].CGColor;
    [self.layer addSublayer:circleMaskLayer];
    
    CAShapeLayer *circleLineLayer = [CAShapeLayer layer];
    [circleLineLayer setFrame:CGRectMake(0, 0, _cropRectView.bounds.size.width, _cropRectView.bounds.size.height)];
    UIBezierPath *circleLinePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 2.0*radius - 2, 2.0*radius - 2)];
    circleLineLayer.path = circleLinePath.CGPath;
    circleLineLayer.strokeColor = [[UIColor whiteColor] CGColor];
    circleLineLayer.lineWidth = 1.0;
    circleLineLayer.fillColor = [[UIColor clearColor] CGColor];
    [_cropRectView.layer addSublayer:circleLineLayer];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint locationInImageView = [self convertPoint:point toView:_zoomingView];
    CGPoint zoomedPoint = CGPointMake(locationInImageView.x * _scrollView.zoomScale, locationInImageView.y * _scrollView.zoomScale);
    if (CGRectContainsPoint(_zoomingView.frame, zoomedPoint)) {
        return _scrollView;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetLayout];
}

- (void)resetLayout
{
    if (!self.image) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        _editingRect = CGRectInset(self.bounds, AvatarMarginLeft, AvatarMarginTop);
    }
    else {
        _editingRect = CGRectInset(self.bounds, AvatarMarginLeft, AvatarMarginLeft);
    }
    
    if (!_imageView) {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            _insetRect = CGRectInset(self.bounds, AvatarMarginLeft, AvatarMarginTop);
        }
        else {
            _insetRect = CGRectInset(self.bounds, AvatarMarginLeft, AvatarMarginLeft);
        }
        [self setupImageView];
    }
    
    [self layoutCropRectViewWithCropRect:_scrollView.frame];
    
    if (_interfaceOrientation != interfaceOrientation) {
        [self zoomToCropRect:_scrollView.frame animated:YES];
    }
    _interfaceOrientation = interfaceOrientation;
}

- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect
{
    [_cropRectView setFrame:cropRect];
}

- (void)setupImageView
{
    CGRect cropRect = [self getCropRect];
    [_scrollView setFrame:cropRect];
    _scrollView.contentSize = cropRect.size;
    
    _zoomingView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    [_zoomingView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_zoomingView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_zoomingView.bounds];
    [_imageView setBackgroundColor:[UIColor clearColor]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = self.image;
    [_zoomingView addSubview:_imageView];
}

- (CGRect)getCropRect
{
    CGRect cropRect = CGRectZero;
    if (self.image.size.height > self.image.size.width) {
        //长竖图
        CGFloat margin = AvatarMarginLeft;
        
        CGFloat scaleImageWidth = self.bounds.size.width - margin*2;
        CGFloat scaleImageHeigh = (self.image.size.height * scaleImageWidth)/self.image.size.width;
        
        CGFloat x = margin;
        CGFloat y = _insetRect.origin.y + (_insetRect.size.height - scaleImageHeigh)/2.0;
        CGFloat w = scaleImageWidth;
        CGFloat h = scaleImageHeigh;
        cropRect = CGRectMake(x, y, w, h);
    }
    else{
        //长横图
        CGFloat margin = AvatarMarginLeft;
        CGFloat scaleImageHeigh = self.bounds.size.width - margin*2;
        CGFloat scaleImageWidth = (self.image.size.width * scaleImageHeigh)/self.image.size.height;
        
        CGFloat x = _insetRect.origin.x + (_insetRect.size.width - scaleImageWidth)/2.0;
        CGFloat y = _insetRect.origin.y + (_insetRect.size.height - scaleImageHeigh)/2.0;
        CGFloat w = scaleImageWidth;
        CGFloat h = scaleImageHeigh;
        cropRect = CGRectMake(x, y, w, h);
    }
    return cropRect;
}

- (void)zoomToCropRect:(CGRect)toRect animated:(BOOL)animated
{
    if (CGRectEqualToRect(_scrollView.frame, toRect)) {
        CGFloat scale_Width = self.bounds.size.width/_cropRectView.frame.size.width;
        _scrollView.zoomScale = scale_Width;
        return;
    }
    
    CGFloat width = CGRectGetWidth(toRect);
    CGFloat height = CGRectGetHeight(toRect);
    
    CGFloat scale = MIN(CGRectGetWidth(_editingRect) / width, CGRectGetHeight(_editingRect) / height);
    
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGRect cropRect = CGRectMake((CGRectGetWidth(self.bounds) - scaledWidth) / 2,
                                 (CGRectGetHeight(self.bounds) - scaledHeight) / 2,
                                 scaledWidth,
                                 scaledHeight);
    
    CGRect zoomRect = [self convertRect:toRect toView:_zoomingView];
    zoomRect.size.width = CGRectGetWidth(cropRect) / (_scrollView.zoomScale * scale);
    zoomRect.size.height = CGRectGetHeight(cropRect) / (_scrollView.zoomScale * scale);
    
    if (animated) {
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _scrollView.bounds = cropRect;
                             [_scrollView zoomToRect:zoomRect animated:NO];
                             
                             [self layoutCropRectViewWithCropRect:cropRect];
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        [_scrollView setFrame:cropRect];
        [_scrollView zoomToRect:toRect animated:NO];
        _scrollView.minimumZoomScale = _scrollView.zoomScale;
        //设置放大的最大比例
        _scrollView.maximumZoomScale = MAX(_scrollView.minimumZoomScale * 2, 4);
        [self layoutCropRectViewWithCropRect:cropRect];
        
        CGFloat scale_Width = self.bounds.size.width/_cropRectView.frame.size.width;
        _scrollView.zoomScale = scale_Width;
        _scrollView.contentOffset = CGPointMake(AvatarMarginLeft, (_scrollView.contentSize.height - _scrollView.frame.size.height)/2.0);
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        [_zoomingView removeFromSuperview];
        _zoomingView = nil;
        
        [self resetLayout];
    }
}

- (void)setAspectRatioWithoutAnimate:(CGFloat)aspectRatio
{
    CGRect cropRect = _scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    
    if (width / height > aspectRatio) {
        width = height * aspectRatio;
    } else {
        height = width * aspectRatio;
    }
    
    cropRect.origin = CGPointMake((self.bounds.size.width - width) / 2, (self.bounds.size.height - height) / 2);
    cropRect.size = CGSizeMake(width, height);
    [self zoomToCropRect:cropRect animated:NO];
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    CGRect cropRect = _scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    //if (width < height) {
    if (width / height > aspectRatio) {
        width = height * aspectRatio;
    } else {
        height = width * aspectRatio;
    }
    cropRect.size = CGSizeMake(width, height);
    [self zoomToCropRect:cropRect animated:YES];
}

- (CGFloat)aspectRatio
{
    CGRect cropRect = _scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    return width / height;
}

- (UIImage *)croppedImage
{
    CGRect cropRect = [self convertRect:_scrollView.frame toView:_zoomingView];
    CGSize size = self.image.size;
    
    CGFloat ratio = 1.0f;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(orientation)) {
        CGRect cropRect = [self getCropRect];
        ratio = CGRectGetWidth(cropRect) / size.width;
    } else {
        CGRect cropRect = [self getCropRect];
        ratio = CGRectGetHeight(cropRect) / size.height;
    }
    
    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
                                       cropRect.origin.y / ratio,
                                       cropRect.size.width / ratio,
                                       cropRect.size.height / ratio);
    
    UIImage *rotatedImage = [self rotatedImageWithImage:self.image transform:_imageView.transform];
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, zoomedCropRect);
    UIImage *image = [UIImage imageWithCGImage:croppedImage scale:1.0f orientation:rotatedImage.imageOrientation];
    CGImageRelease(croppedImage);
    
    return image;
}

- (UIImage *)rotatedImageWithImage:(UIImage *)image transform:(CGAffineTransform)transform
{
    CGSize size = image.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGPoint center = _zoomingView.center;
    CGPoint contentOffset = _scrollView.contentOffset;
    if (_scrollView.bounds.size.width > _imageView.bounds.size.width) {
        center.x = _scrollView.bounds.size.width/2 >= _imageView.frame.size.width/2 ?_scrollView.bounds.size.width/2 : _imageView.frame.size.width/2;
        contentOffset.x = (_scrollView.contentSize.width/2 - _scrollView.bounds.size.width/2) >= 0?(_scrollView.contentSize.width/2 - _scrollView.bounds.size.width/2):0;
    }
    if (_scrollView.bounds.size.height > _imageView.bounds.size.height) {
        center.y = _scrollView.frame.size.height/2 >= _imageView.frame.size.height/2 ?_scrollView.frame.size.height/2:_imageView.frame.size.height/2;
        contentOffset.y = (_scrollView.contentSize.height/2 - _scrollView.bounds.size.height/2) >= 0?(_scrollView.contentSize.height/2 - _scrollView.bounds.size.height/2):0;
    }
    
    _zoomingView.center = center;
    _scrollView.contentOffset = contentOffset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomingView;
}


@end
