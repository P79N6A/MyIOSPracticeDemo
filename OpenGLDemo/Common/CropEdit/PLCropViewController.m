//
//  PLCropViewController.m
//  HuaYang
//
//  Created by zekaizhang on 16/7/5.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PLCropViewController.h"
#import "PLCropView.h"
#import "PLUtilUIScreen.h"
#import "ColorDefine.h"

@interface PLCropViewController ()  {
    UIImage* _image;
    CGSize _cropSize;
    CGRect _lastNavigationBarFrame;
    PLCropView* _cropView;
    //    QQImagePickerBottomBar* _bottomBar;
}
@end

@implementation PLCropViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.view.clipsToBounds = YES;
    
    _cropView = [[PLCropView alloc] initWithFrame:self.view.bounds];
    _cropView.isShowAvatarPendant = _isShowAvatarPendant;
    [self.view addSubview:_cropView];
    
    // 顶部导航栏
    //    UIView* headerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    //    [headerBar setBackgroundColor:RGBACOLOR(0, 0, 0, 0.7)];
    //    [self.view addSubview:headerBar];
    //
    //    // 左上角按钮
    //    UIImage* icon = [UIImage loadImage:@"PersonalLive/StartLive/photo_browser_header_icon_back_nor.png"];
    //    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftButton setFrame:CGRectMake(0, (headerBar.bounds.size.height - icon.size.height) / 2, icon.size.width + 40, icon.size.height)];
    //    [leftButton setImage:icon forState:UIControlStateNormal];
    //    [leftButton setImage:[UIImage loadImage:@"PersonalLive/StartLive/photo_browser_header_icon_back_pressed.png"] forState:UIControlStateHighlighted];
    //    [leftButton addTarget:self action:@selector(onLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [headerBar addSubview:leftButton];
    
    // 底部bar
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, SCREEN_WIDTH, 60)];
    [bottomBar setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [self.view addSubview:bottomBar];
    UIButton* sureButt = [[UIButton alloc] initWithFrame:CGRectMake(bottomBar.frame.size.width-10-50, (bottomBar.frame.size.height-50)/2.f, 50, 50)];
    sureButt.backgroundColor = [UIColor clearColor];
    sureButt.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [sureButt setTitle:@"确定" forState:UIControlStateNormal];
    [sureButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButt addTarget:self action:@selector(onSureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:sureButt];
    
    UIButton* leftButt = [[UIButton alloc] initWithFrame:CGRectMake(10, (bottomBar.frame.size.height-50)/2.f, 50, 50)];
    leftButt.backgroundColor = [UIColor clearColor];
    leftButt.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [leftButt setTitle:@"取消" forState:UIControlStateNormal];
    [leftButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(onLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:leftButt];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _cropView.image = _image;
    [_cropView setAspectRatioWithoutAnimate:_cropSize.width / _cropSize.height];
    
    if (_isShowAvatarPendant) {
        [_cropView addAvatarPendantView];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 备份
    _lastNavigationBarFrame = self.navigationController.navigationBar.frame;
    
    // 隐藏导航栏和状态栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)onLeftButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [_delegate cropViewControllerDidCancel:self];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        // 最好压缩一下
        _image = image;
        //        _image = [[image scaleImageToFitMemory] retain];
        _cropView.image = _image;
    }
}

-(void)onSureButtonClick:(id)sender
{
    [_parentController  dismissViewControllerAnimated:NO completion:nil];
    
    if ([_delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        UIImage* editedImage = _cropView.croppedImage;
        //        editedImage = [ImageHelper image:editedImage scaleAspectFitSize:_cropSize];
        [_delegate cropViewController:self didFinishCroppingImage:editedImage];
    }
}
@end
