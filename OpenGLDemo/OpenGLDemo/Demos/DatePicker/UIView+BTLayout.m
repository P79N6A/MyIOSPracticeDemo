//
//  UIView+BTLayout.m
//  Mango
//
//  Created by britayin on 2017/11/7.
//  Copyright © 2017年 z28j. All rights reserved.
//

#import "UIView+BTLayout.h"

@implementation UIView (BTLayout)

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
    self.frame = CGRectMake(self.pX, self.pY, w, h);
}

- (void)pSetOriginX:(CGFloat)x Y:(CGFloat)y
{
    self.frame = CGRectMake(x, y, self.pWidth, self.pHeight);
}

- (CGFloat)pWidth
{
    return self.pSize.width;
}

- (void)setPWidth:(CGFloat)width
{
    [self pSetSizeW:width H:self.pHeight];
}

- (CGFloat)pHeight
{
    return self.pSize.height;
}

- (void)setPHeight:(CGFloat)height
{
    [self pSetSizeW:self.pWidth H:height];
}

- (CGFloat)pX
{
    return self.pOrigin.x;
}

- (void)setPX:(CGFloat)x
{
    [self pSetOriginX:x Y:self.pY];
}

- (CGFloat)pY
{
    return self.pOrigin.y;
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






- (void)sAlignBottom:(UIView *)view offset:(CGFloat)offset
{
    self.sBottom = view.sBottom+offset;
}

- (void)sAlignBottom:(UIView *)view
{
    [self sAlignBottom:view offset:0];
}

- (void)sAlignParentBottomOffset:(CGFloat)offset
{
    self.sBottom = self.superview.sHeight+offset;
}

- (void)sAlignParentBottom
{
    [self sAlignParentBottomOffset:0];
}

- (void)sAlignTop:(UIView *)view offset:(CGFloat)offset
{
    self.sTop = view.sTop + offset;
}

- (void)sAlignTop:(UIView *)view
{
    [self sAlignTop:view offset:0];
}

- (void)sAlignParentTopOffset:(CGFloat)offset
{
    self.sTop = offset;
}

- (void)sAlignParentTop
{
    [self sAlignParentTopOffset:0];
}

- (void)sAlignRight:(UIView *)view offset:(CGFloat)offset
{
    self.sRight = view.sRight + offset;
}

- (void)sAlignRight:(UIView *)view
{
    [self sAlignRight:view offset:0];
}

- (void)sAlignParentRightOffset:(CGFloat)offset
{
    self.sRight = self.superview.sWidth + offset;
}

- (void)sAlignParentRight
{
    [self sAlignParentRightOffset:0];
}

- (void)sAlignLeft:(UIView *)view offset:(CGFloat)offset
{
    self.sLeft = view.sLeft + offset;
}

- (void)sAlignLeft:(UIView *)view
{
    [self sAlignLeft:view offset:0];
}

- (void)sAlignParentLeftOffset:(CGFloat)offset
{
    self.sLeft = offset;
}

- (void)sAlignParentLeft
{
    [self sAlignParentLeftOffset:0];
}

- (void)sBelow:(UIView *)view margin:(CGFloat)margin
{
    self.sTop = view.sBottom + margin;
}

- (void)sAbove:(UIView *)view margin:(CGFloat)margin
{
    self.sBottom = view.sTop - margin;
}

- (void)sRightTo:(UIView *)view margin:(CGFloat)margin
{
    self.sLeft = view.sRight + margin;
}

- (void)sLeftTo:(UIView *)view margin:(CGFloat)margin
{
    self.sRight = view.sLeft - margin;
}

- (void)sSetSizeW:(CGFloat)w H:(CGFloat)h
{
    self.frame = CGRectMake(self.sX, self.sY, w, h);
}

- (void)sSetOriginX:(CGFloat)x Y:(CGFloat)y
{
    self.frame = CGRectMake(x, y, self.sWidth, self.sHeight);
}

- (CGFloat)sWidth
{
    return self.sSize.width;
}

- (void)setSWidth:(CGFloat)width
{
    [self sSetSizeW:width H:self.sHeight];
}

- (CGFloat)sHeight
{
    return self.sSize.height;
}

- (void)setSHeight:(CGFloat)height
{
    [self sSetSizeW:self.sWidth H:height];
}

- (CGFloat)sX
{
    return self.sOrigin.x;
}

- (void)setSX:(CGFloat)x
{
    CGFloat oRight = self.sRight;
    [self sSetOriginX:x Y:self.sY];
    self.sRight = oRight;
}

- (CGFloat)sY
{
    return self.sOrigin.y;
}

- (void)setSY:(CGFloat)y
{
    CGFloat oBottom = self.sBottom;
    [self sSetOriginX:self.sX Y:y];
    self.sBottom = oBottom;
}

- (CGFloat)sTop
{
    return self.sY;
}

- (void)setSTop:(CGFloat)sTop
{
    self.sY = sTop;
}

- (CGFloat)sBottom
{
    return self.sY+self.sHeight;
}

- (void)setSBottom:(CGFloat)sBottom
{
    if (sBottom > self.sTop) {
        self.sHeight = sBottom - self.sTop;
    }else{
        self.sHeight = 0;
    }
}

- (CGFloat)sLeft
{
    return self.sX;
}

- (void)setSLeft:(CGFloat)sLeft
{
    self.sX = sLeft;
}

- (CGFloat)sRight
{
    return self.sX+self.sWidth;
}

- (void)setSRight:(CGFloat)sRight
{
    if (sRight > self.sX) {
        self.sWidth = sRight - self.sX;
    }else{
        self.sWidth = 0;
    }
}

- (CGSize)sSize
{
    return self.frame.size;
}

- (void)setSSize:(CGSize)sSize
{
    [self sSetSizeW:sSize.width H:sSize.height];
}

- (CGPoint)sOrigin
{
    return self.frame.origin;
}

- (void)setSOrigin:(CGPoint)sOrigin
{
    self.sX = sOrigin.x;
    self.sY = sOrigin.y;
}

- (void)sizeAsParent
{
    [self sizeAsParentMargin:0];
}

- (void)sizeAsParentMargin:(CGFloat)margin
{
    [self sizeAsParentMargins:UIEdgeInsetsMake(margin, margin, margin, margin)];
}

- (void)sizeAsParentMargins:(UIEdgeInsets)margins
{
    [self widthAsParentMarginsLeft:margins.left right:margins.right];
    [self heightAsParentMarginsTop:margins.top bottom:margins.bottom];
}

- (void)widthAsParent
{
    [self widthAsParentMargin:0];
}

- (void)widthAsParentMargin:(CGFloat)margin
{
    [self widthAsParentMarginsLeft:margin right:margin];
}

- (void)widthAsParentMarginsLeft:(CGFloat)leftMargin right:(CGFloat)rightMargin
{
    self.sLeft = leftMargin;
    self.sRight = self.superview.sWidth - rightMargin;
}

- (void)heightAsParent
{
    [self heightAsParentMargin:0];
}

- (void)heightAsParentMargin:(CGFloat)margin
{
    [self heightAsParentMarginsTop:margin bottom:margin];
}

- (void)heightAsParentMarginsTop:(CGFloat)topMargin bottom:(CGFloat)bottomtMargin
{
    self.sTop = topMargin;
    self.sBottom = self.superview.sHeight - bottomtMargin;
}

@end
