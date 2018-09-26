//  Created by applechang on 2018/3/8.
//  Copyright © 2018年 tencent. All rights reserved.

#import <UIKit/UIKit.h>

@protocol ODCloseLianmaiButtonViewDelegate <NSObject>
@required
-(void)onClickCloseLianmaiButton;
@end

@interface ODShadowLayerView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end

@interface ODLongPressCloseLianmaiGuideView : ODShadowLayerView
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end

@interface ODLongPressCloseLianmaiButtonView : ODShadowLayerView
@property (nonatomic, weak) id<ODCloseLianmaiButtonViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end

