//
//  PLCropViewController.h
//  HuaYang
//
//  Created by zekaizhang on 16/7/5.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLCropViewController;
@protocol PLCropViewControllerDelegate <NSObject>

- (void)cropViewController:(PLCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;
- (void)cropViewControllerDidCancel:(PLCropViewController *)controller;

@end

@interface PLCropViewController : UIViewController
{
    BOOL _isShowAvatarPendant;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGSize cropSize;
@property (nonatomic, assign) BOOL isShowAvatarPendant;
@property (nonatomic, weak) id<PLCropViewControllerDelegate> delegate;
@property (nonatomic, retain) UIViewController *parentController;

@end
