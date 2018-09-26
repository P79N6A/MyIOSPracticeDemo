//
//  CommonUIDefine.h
//  CommonUI
//
//  Created by 张晏兵 on 14-10-10.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#ifndef __COMMONUI_DEFINE_H__
#define __COMMONUI_DEFINE_H__

//判断是否高清屏
#define  IS_RETINA ([UIScreen instancesRespondToSelector:@selector(scale)] ? ([[UIScreen mainScreen] scale] > 1) : NO)

//获取颜色值
#define GetAValue(argb) (unsigned char)((argb) >> 24)
#define GetRValue(argb) (unsigned char)((argb) >> 16)
#define GetGValue(argb) (unsigned char)((argb) >> 8)
#define GetBValue(argb) (unsigned char)(argb)

//将ARGB转换成UIColor
#define ARGB2UICOLOR(A,R,G,B) [UIColor colorWithRed:(R / 255.0) green:(G / 255.0) blue:(B / 255.0) alpha:(A / 255.0)]
#define RGB2UICOLOR(R,G,B)  [UIColor colorWithRed:(R / 255.0) green:(G / 255.0) blue:(B / 255.0) alpha:1.0]

#define ARGB2UICOLOR2(argb) [UIColor colorWithRed:(GetRValue((argb)) / 255.0) green:(GetGValue((argb)) / 255.0) blue:(GetBValue((argb)) / 255.0) alpha:(GetAValue((argb)) / 255.0)]
#define RGB2UICOLOR2(rgb) [UIColor colorWithRed:(GetRValue((rgb)) / 255.0) green:(GetGValue((rgb)) / 255.0) blue:(GetBValue((rgb)) / 255.0) alpha:1.0]

#define ONE_PIXEL_SPACEING  (([[UIScreen mainScreen] scale] >= 1) ? (1.0 / [[UIScreen mainScreen] scale]) : 1.0)
#endif  //__COMMONUI_DEFINE_H__
