//
//  UIView+BTPosition.h
//  ODApp
//
//  Created by britayin on 2017/6/9.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 纯粹的frame设置，无约束关系，如果需要更新关系，需要重新设置. 应先确认被依赖的frame已经设置好才能开始设置依赖关系.
 各个函数调用都是根据已知的size来设置其位置，因此调用前需保证依赖的size都被正确设置
 */
@interface UIView (BTPosition)

@property (nonatomic) CGFloat pX;
@property (nonatomic) CGFloat pY;
@property (nonatomic) CGFloat pWidth;
@property (nonatomic) CGFloat pHeight;

@property (nonatomic) CGFloat pTop;
@property (nonatomic) CGFloat pBottom;
@property (nonatomic) CGFloat pLeft;
@property (nonatomic) CGFloat pRight;

@property (nonatomic) CGFloat pCenterX;
@property (nonatomic) CGFloat pCenterY;
@property (nonatomic) CGPoint pCenter;

@property (nonatomic) CGSize pSize;
@property (nonatomic) CGPoint pOrigin;

//依赖于height都已正确设置
- (void)pAlignBottom:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignBottom:(UIView *)view;

- (void)pAlignParentBottomOffset:(CGFloat)offset;
- (void)pAlignParentBottom;

//依赖于height都已正确设置
- (void)pAlignTop:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignTop:(UIView *)view;

- (void)pAlignParentTopOffset:(CGFloat)offset;
- (void)pAlignParentTop;

//依赖于width都已正确设置
- (void)pAlignLeft:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignLeft:(UIView *)view;

- (void)pAlignParentLeftOffset:(CGFloat)offset;
- (void)pAlignParentLeft;

//依赖于width都已正确设置
- (void)pAlignRight:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignRight:(UIView *)view;

- (void)pAlignParentRightOffset:(CGFloat)offset;
- (void)pAlignParentRight;

//依赖于width都已正确设置
- (void)pAlignCenterX:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignCenterX:(UIView *)view;

- (void)pAlignParentCenterXOffset:(CGFloat)offset;
- (void)pAlignParentCenterX;

//依赖于height都已正确设置
- (void)pAlignCenterY:(UIView *)view offset:(CGFloat)offset;
- (void)pAlignCenterY:(UIView *)view;

- (void)pAlignParentCenterYOffset:(CGFloat)offset;
- (void)pAlignParentCenterY;

//依赖于width，height都已正确设置
- (void)pAlignCenter:(UIView *)view;
- (void)pAlignParentCenter;

//依赖于height已正确设置
- (void)pBelow:(UIView *)view margin:(CGFloat)margin;
//依赖于height已正确设置
- (void)pAbove:(UIView *)view margin:(CGFloat)margin;
//依赖于width已正确设置
- (void)pRightTo:(UIView *)view margin:(CGFloat)margin;
//依赖于width已正确设置
- (void)pLeftTo:(UIView *)view margin:(CGFloat)margin;

@end
