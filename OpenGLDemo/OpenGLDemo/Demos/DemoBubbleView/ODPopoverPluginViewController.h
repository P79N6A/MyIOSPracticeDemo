//
//  ODPopoverPluginViewController.h
//  ODApp
//
//  Created by britayin on 2017/6/1.
//  Copyright © 2017年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void (^ ODPopoverAnimBlock)();
/**
 弹出的浮层，自带点击空白处消失功能
 */
@interface ODPopoverPluginViewController : UIViewController
@property (nonatomic, assign) BOOL initHide;    //加载时是否默认隐藏（调用show显示）
@property (nonatomic, retain) UIView *mainView; //主浮层面板
@property (nonatomic, assign) BOOL hideWidthUnload; //hide后是否自动卸载
//@property (nonatomic, assign) BOOL hideWhenClickOtherArea;  //是否点击空白区域自动hide。默认YES

- (BOOL)show;
- (BOOL)hide;
- (BOOL)showWithAnim:(CAAnimation *)anim;
- (BOOL)hideWithAnim:(CAAnimation *)anim;


/**
 进场动画开始
 */
- (void)willViewAnimIn;

/**
 进场动画结束
 */
- (void)didViewAnimIn;

/**
 出场动画开始
 */
- (void)willViewAnimOut;

/**
 出场动画结束
 */
- (void)didViewAnimOut;

@end
