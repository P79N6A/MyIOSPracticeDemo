//
//  ColorDefine.h
//  HuaYang
//
//  Created by justinsong on 16/5/31.
//  Copyright © 2016年 tencent. All rights reserved.
//
#import "UIColor+Ext.h"

#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBColorC(h)      RGBColor(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define RGBAColorC(h,a)   RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)


// RGB颜色
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define HEXRGBCOLOR(h)      RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a)   RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#define RGBAColorC(h,a)     RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#define CLEARCOLOR          [UIColor clearColor]
#define IOS7NavColor        [UIColor colorWithRed:174/255.0 green:6/255.0 blue:15/255.0 alpha:1]

#define GET_REAL_PIXEL(x) (x * [UIScreen mainScreen].scale)

#define RECT_GET_CENTER(rc) CGPointMake(rc.origin.x + rc.size.width / 2, rc.origin.y + rc.size.height / 2)
