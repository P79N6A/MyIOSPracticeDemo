//
//  UIView+pPosition.m
//  ODApp
//
//  Created by britayin on 2017/6/9.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "UIView+BTPosition.h"

@implementation UIView (BTPosition)


- (void)pAlignBottom:(UIView *)view offset:(CGFloat)offset
{
    self.pBottom = view.pBottom+offset;
}

- (void)pAlignBottom:(UIView *)view
{
    [self pAlignBottom:view offset:0];
}

- (void)pAlignParentBottomOffset:(CGFloat)offset
{
    self.pBottom = self.superview.pHeight+offset;
}

- (void)pAlignParentBottom
{
    [self pAlignParentBottomOffset:0];
}

- (void)pAlignTop:(UIView *)view offset:(CGFloat)offset
{
    self.pTop = view.pTop + offset;
}

- (void)pAlignTop:(UIView *)view
{
    [self pAlignTop:view offset:0];
}

- (void)pAlignParentTopOffset:(CGFloat)offset
{
    self.pTop = offset;
}

- (void)pAlignParentTop
{
    [self pAlignParentTopOffset:0];
}

- (void)pAlignRight:(UIView *)view offset:(CGFloat)offset
{
    self.pRight = view.pRight + offset;
}

- (void)pAlignRight:(UIView *)view
{
    [self pAlignRight:view offset:0];
}

- (void)pAlignParentRightOffset:(CGFloat)offset
{
    self.pRight = self.superview.pWidth + offset;
}

- (void)pAlignParentRight
{
    [self pAlignParentRightOffset:0];
}

- (void)pAlignLeft:(UIView *)view offset:(CGFloat)offset
{
    self.pLeft = view.pLeft + offset;
}

- (void)pAlignLeft:(UIView *)view
{
    [self pAlignLeft:view offset:0];
}

- (void)pAlignParentLeftOffset:(CGFloat)offset
{
    self.pLeft = offset;
}

- (void)pAlignParentLeft
{
    [self pAlignParentLeftOffset:0];
}

- (void)pAlignCenterX:(UIView *)view offset:(CGFloat)offset
{
    self.pCenterX = view.pCenterX + offset;
}

- (void)pAlignCenterX:(UIView *)view
{
    [self pAlignCenterX:view offset:0];
}

- (void)pAlignParentCenterXOffset:(CGFloat)offset
{
    self.pCenterX = self.superview.pWidth/2 + offset;
}

- (void)pAlignParentCenterX
{
    [self pAlignParentCenterXOffset:0];
}

- (void)pAlignCenterY:(UIView *)view offset:(CGFloat)offset
{
    self.pCenterY = view.pCenterY + offset;
}

- (void)pAlignCenterY:(UIView *)view
{
    [self pAlignCenterY:view offset:0];
}

- (void)pAlignParentCenterYOffset:(CGFloat)offset
{
    self.pCenterY = self.superview.pHeight/2 + offset;
}

- (void)pAlignParentCenterY
{
    [self pAlignParentCenterYOffset:0];
}

- (void)pAlignCenter:(UIView *)view
{
    [self pAlignCenterX:view];
    [self pAlignCenterY:view];
}

- (void)pAlignParentCenter
{
    [self pAlignParentCenterX];
    [self pAlignParentCenterY];
}

- (void)pBelow:(UIView *)view margin:(CGFloat)margin
{
    self.pTop = view.pBottom + margin;
}

- (void)pAbove:(UIView *)view margin:(CGFloat)margin
{
    self.pBottom = view.pTop - margin;
}

- (void)pRightTo:(UIView *)view margin:(CGFloat)margin
{
    self.pLeft = view.pRight + margin;
}

- (void)pLeftTo:(UIView *)view margin:(CGFloat)margin
{
    self.pRight = view.pLeft - margin;
}

- (void)pSetSizeW:(CGFloat)w H:(CGFloat)h
{
    CZ_setFrame(self, CGRectMake(self.CZ_F_OriginX, self.CZ_F_OriginY, w, h));
}

- (void)pSetOriginX:(CGFloat)x Y:(CGFloat)y
{
    CZ_setFrame(self, CGRectMake(x, y, self.CZ_F_SizeW, self.CZ_F_SizeH));
}

- (CGFloat)pWidth
{
    return self.CZ_F_SizeW;
}

- (void)setPWidth:(CGFloat)width
{
    [self pSetSizeW:width H:self.pHeight];
}

- (CGFloat)pHeight
{
    return self.CZ_F_SizeH;
}

- (void)setPHeight:(CGFloat)height
{
    [self pSetSizeW:self.pWidth H:height];
}

- (CGFloat)pX
{
    return self.CZ_F_OriginX;
}

- (void)setPX:(CGFloat)x
{
    [self pSetOriginX:x Y:self.pY];
}

- (CGFloat)pY
{
    return self.CZ_F_OriginY;
}

- (void)setPY:(CGFloat)y
{
    [self pSetOriginX:self.pX Y:y];
}

- (CGFloat)pTop
{
    return self.pY;
}

- (void)setPTop:(CGFloat)pTop
{
    self.pY = pTop;
}

- (CGFloat)pBottom
{
    return self.pY+self.pHeight;
}

- (void)setPBottom:(CGFloat)pBottom
{
    self.pY = pBottom-self.pHeight;
}

- (CGFloat)pLeft
{
    return self.pX;
}

- (void)setPLeft:(CGFloat)pLeft
{
    self.pX = pLeft;
}

- (CGFloat)pRight
{
    return self.pX+self.pWidth;
}

- (void)setPRight:(CGFloat)pRight
{
    self.pX = pRight-self.pWidth;
}

- (CGFloat)pCenterX
{
    return self.pX + self.pWidth/2;
}

- (void)setPCenterX:(CGFloat)pCenterX
{
    self.pX = pCenterX - self.pWidth/2;
}

- (CGFloat)pCenterY
{
    return self.pY + self.pHeight/2;
}

- (void)setPCenterY:(CGFloat)pCenterY
{
    self.pY = pCenterY - self.pHeight/2;
}

- (CGPoint)pCenter
{
    return CGPointMake(self.pCenterX, self.pCenterY);
}

- (void)setPCenter:(CGPoint)pCenter
{
    self.pCenterX = pCenter.x;
    self.pCenterY = pCenter.y;
}

- (CGSize)pSize
{
    return self.frame.size;
}

- (void)setPSize:(CGSize)pSize
{
    [self pSetSizeW:pSize.width H:pSize.height];
}

- (CGPoint)pOrigin
{
    return self.frame.origin;
}

- (void)setPOrigin:(CGPoint)pOrigin
{
    [self pSetOriginX:pOrigin.x Y:pOrigin.y];
}

OCS_PLUGIN_METHODS_END
#endif

@end
