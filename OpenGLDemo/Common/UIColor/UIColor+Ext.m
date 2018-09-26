//
//  UIColor+Ext.m
//  WeGroup
//
//  Created by kylewu on 15/2/4.
//  Copyright (c) 2015年 stack. All rights reserved.
//

#import "UIColor+Ext.h"

@implementation UIColor (Ext)

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    return [UIColor colorWithR:r G:g B:b alpha:1.0f];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha
{
    CGFloat red   = r/0xFF;
    CGFloat green = g/0xFF;
    CGFloat blue  = b/0xFF;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    return [UIColor colorWithRGBHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithR:r G:g B:b alpha:alpha];
}

@end
