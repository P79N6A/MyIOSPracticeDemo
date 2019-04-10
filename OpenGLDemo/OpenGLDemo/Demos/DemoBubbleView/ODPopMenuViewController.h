//
//  ODPopMenuViewController.h
//  ODApp
//
//  Created by britayin on 2017/6/1.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "ODPopoverPluginViewController.h"
#import "ODPopMenuItem.h"

@class ODPopMenuItem;


@protocol ODPopMenuViewDelegate <NSObject>
@required
- (void)didMenuSelected:(ODPopMenuItem *)item atIndex:(NSInteger)index;

@end



@protocol ODPopTipsViewDelegate <NSObject>
@required
- (void)tipsDisappear;

@end


@interface ODPopTipViewItem:NSObject
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, retain) NSArray* menuData;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isSingleLineTips;
@property (nonatomic, assign) NSTimeInterval hideAfterSec;
@property (nonatomic, weak) id<ODPopTipsViewDelegate> tipsDelegate;
@property (nonatomic, assign) BOOL expire;
@end


@interface ODPopMenuViewController : ODPopoverPluginViewController

@property (nonatomic, weak) id<ODPopMenuViewDelegate> delegate;
@property (nonatomic, weak) id<ODPopTipsViewDelegate> tipsDelegate;
@property (nonatomic, assign) BOOL singleLineTips;  //是否是单行提示

//- (void)showIn:(CGPoint)point menus:(NSArray *)menuData isUp:(bool)isUp;
- (void)tipsSchedule:(ODPopTipViewItem*)item;
//- (void)hideAfterSeconds:(ODPopTipViewItem*)seconds;

- (BOOL)isShowing;

@end
