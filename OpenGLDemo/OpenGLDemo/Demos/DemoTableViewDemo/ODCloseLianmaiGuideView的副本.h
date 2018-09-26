//  Created by applechang on 2018/3/8.
//  Copyright © 2018年 tencent. All rights reserved.

#import <UIKit/UIKit.h>
@protocol ODCloseLianmaiGuideViewDelegate <NSObject>
-(void)onClickCloseLianmai;
@end

@interface ODCloseLianmaiGuideView : UIView

@property (nonatomic, weak) id<ODCloseLianmaiGuideViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showGuide;
- (void)showCloseButton;
@end
