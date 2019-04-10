//
//  UIView+BTVFL.h
//  ODApp
//
//  Created by britayin on 2017/5/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 "让VFL的调用更简单"
 VFL用法参见 https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html
 */
@interface UIView (BTVFL)

/**
 将自己与目标View水平对齐
 
 @param view 目标View，只能是父View或者兄弟View
 */
- (void)centerXTo:(UIView *)view;


/**
 将自己与目标View垂直对齐
 
 @param view 目标View，只能是父View或者兄弟View
 */
- (void)centerYTo:(UIView *)view;


/**
 将自己与目标View中心对齐
 
 @param view 只能是父View或者兄弟View
 */
- (void)centerTo:(UIView *)view;

/**
 将自己的attr属性与view对其
 @param view 只能是父View或者兄弟view
 */
-(void)alignToView:(UIView *)view Attribute:(NSLayoutAttribute) attr;


/**
 自己的某个属性与目标View对齐

 @param attribute 属性
 @param view 只能是父View或者兄弟View
 */
- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view;


/**
 自己的某个属性与目标View对齐

 @param attribute 属性
 @param view 只能是父View或者兄弟View
 @param offset 偏移量
 */
- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view offset:(CGFloat)offset;
- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view attribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset;
- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view attribute:(NSLayoutAttribute)toAttribute multiplier:(CGFloat)multiplier offset:(CGFloat)offset;

- (void)alignTop:(UIView *)view;
- (void)alignBottom:(UIView *)view;
- (void)alignLeft:(UIView *)view;
- (void)alignRight:(UIView *)view;

- (void)alignTop:(UIView *)view offset:(CGFloat)offset;
- (void)alignBottom:(UIView *)view offset:(CGFloat)offset;
- (void)alignLeft:(UIView *)view offset:(CGFloat)offset;
- (void)alignRight:(UIView *)view offset:(CGFloat)offset;

- (void)widthEqual:(UIView *)view;
- (void)widthEqualValue:(CGFloat)width;
- (void)heightEqual:(UIView *)view;
- (void)heightEqualValue:(CGFloat)height;
- (void)sizeEqual:(UIView *)view;
- (void)sizeEqualValue:(CGSize)size;

- (void)belowTo:(UIView *)view margin:(CGFloat)margin;
- (void)rightTo:(UIView *)view margin:(CGFloat)margin;
- (void)aboveTo:(UIView *)view margin:(CGFloat)margin;
- (void)leftTo:(UIView *)view margin:(CGFloat)margin;

@end

