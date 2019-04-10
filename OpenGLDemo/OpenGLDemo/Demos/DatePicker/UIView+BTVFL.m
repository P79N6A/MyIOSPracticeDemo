#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIView+BTVFL.m"
#pragma clang diagnostic pop


//
//  UIView+BTVFL.m
//  ODApp
//
//  Created by britayin on 2017/5/24.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "UIView+BTVFL.h"

@implementation UIView (BTVFL)

- (void)centerXTo:(UIView *)view
{
    [self attribute:NSLayoutAttributeCenterX equal:view];
}

- (void)centerYTo:(UIView *)view
{
    [self attribute:NSLayoutAttributeCenterY equal:view];
}

- (void)centerTo:(UIView *)view
{
    [self centerXTo:view];
    [self centerYTo:view];
}

-(void)alignToView:(UIView *)view Attribute:(NSLayoutAttribute) attr
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:view attribute:attr multiplier:1 constant:0]];
}


- (void)attribute:(NSLayoutAttribute)attribute equalValue:(CGFloat)value
{
    [self attribute:attribute equal:nil attribute:NSLayoutAttributeNotAnAttribute offset:value];
}

- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view
{
    [self attribute:attribute equal:view offset:0];
}

- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view offset:(CGFloat)offset
{
    [self attribute:attribute equal:view attribute:attribute offset:offset];
}

- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view attribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset
{
    [self attribute:attribute equal:view attribute:toAttribute multiplier:1 offset:offset];
}

- (void)attribute:(NSLayoutAttribute)attribute equal:(UIView *)view attribute:(NSLayoutAttribute)toAttribute multiplier:(CGFloat)multiplier offset:(CGFloat)offset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [[self superview] safeAddConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:toAttribute multiplier:multiplier constant:offset]];
}

- (void)safeAddConstraint:(NSLayoutConstraint *)constraint
{
    NSMutableArray *confictConstraints;
    for (NSLayoutConstraint *tConstraint in self.constraints) {
        if (tConstraint.firstItem == constraint.firstItem && tConstraint.secondItem == constraint.secondItem) {
            if (tConstraint.firstAttribute == constraint.firstAttribute && tConstraint.secondAttribute == constraint.secondAttribute) {
                if (!confictConstraints) confictConstraints = [[NSMutableArray alloc] init];;
                [confictConstraints addObject:tConstraint];
            }
        }
    }
    if(confictConstraints) [self removeConstraints:confictConstraints];
    [self addConstraint:constraint];
}

- (void)alignTop:(UIView *)view
{
    [self attribute:NSLayoutAttributeTop equal:view];
}


- (void)alignBottom:(UIView *)view
{
    [self attribute:NSLayoutAttributeBottom equal:view];
}


- (void)alignLeft:(UIView *)view
{
    [self attribute:NSLayoutAttributeLeft equal:view];
}


- (void)alignRight:(UIView *)view
{
    [self attribute:NSLayoutAttributeRight equal:view];
}

- (void)alignTop:(UIView *)view offset:(CGFloat)offset
{
    [self attribute:NSLayoutAttributeTop equal:view offset:offset];
}


- (void)alignBottom:(UIView *)view offset:(CGFloat)offset
{
    [self attribute:NSLayoutAttributeBottom equal:view offset:offset];
}


- (void)alignLeft:(UIView *)view offset:(CGFloat)offset
{
    [self attribute:NSLayoutAttributeLeft equal:view offset:offset];
}


- (void)alignRight:(UIView *)view offset:(CGFloat)offset
{
    [self attribute:NSLayoutAttributeRight equal:view offset:offset];
}

- (void)widthEqual:(UIView *)view
{
    [self attribute:NSLayoutAttributeWidth equal:view];
}

- (void)widthEqualValue:(CGFloat)width
{
    [self attribute:NSLayoutAttributeWidth equalValue:width];
}

- (void)heightEqual:(UIView *)view
{
    [self attribute:NSLayoutAttributeHeight equal:view];
}

- (void)heightEqualValue:(CGFloat)height
{
    [self attribute:NSLayoutAttributeHeight equalValue:height];
}

- (void)sizeEqual:(UIView *)view
{
    [self widthEqual:view];
    [self heightEqual:view];
}

- (void)sizeEqualValue:(CGSize)size
{
    [self widthEqualValue:size.width];
    [self heightEqualValue:size.height];
}

- (void)belowTo:(UIView *)view margin:(CGFloat)margin
{
    [self attribute:NSLayoutAttributeTop equal:view attribute:NSLayoutAttributeBottom offset:margin];
}

- (void)rightTo:(UIView *)view margin:(CGFloat)margin
{
    [self attribute:NSLayoutAttributeLeft equal:view attribute:NSLayoutAttributeRight offset:margin];
}

- (void)aboveTo:(UIView *)view margin:(CGFloat)margin
{
    [self attribute:NSLayoutAttributeBottom equal:view attribute:NSLayoutAttributeTop offset:-margin];
}

- (void)leftTo:(UIView *)view margin:(CGFloat)margin
{
    [self attribute:NSLayoutAttributeRight equal:view attribute:NSLayoutAttributeLeft offset:-margin];
}

@end
