//
//  PLCropView.h
//  HuaYang
//
//  Created by zekaizhang on 16/7/5.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLCropView : UIView
{
    UIImage *_image;
    UIImage *_croppedImage;
    BOOL _isShowAvatarPendant;
    CGFloat _aspectRatio;
    CGRect _cropRect;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic, assign) BOOL isShowAvatarPendant;
@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic) CGRect cropRect;

- (void)setAspectRatioWithoutAnimate:(CGFloat)aspectRatio;
- (void)addAvatarPendantView;
@end
