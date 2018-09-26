//
//  PLUtilUIScreen.h
//  HuaYang
//
//  Created by 张晏兵 on 14-10-11.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLUtilUIScreen : NSObject

+ (int)screenWidth;
+ (int)screenHeight;
+ (int)statusBarHeight;
+ (int)navigationBarHeight;
+ (int)toolBarHeight;
+ (int)topBarHeight;
+ (BOOL)ptInRect:(CGPoint)point rect:(CGRect)rect;
+ (CGFloat)fitWidthBy6:(CGFloat)width;
+ (CGFloat)fitHeightBy6:(CGFloat)height;
+ (CGFloat)fitFontBy6:(CGFloat)value;
+ (CGRect)rectWithInset:(CGRect)rect inset:(UIEdgeInsets)insets;
//横屏
+ (int)screenWidthOri;
+ (int)screenHeightOri;

+ (bool)isiPhone5;

// iPhoneX适配
+ (BOOL)isiPhoneX;
+ (UIEdgeInsets)safeAreaForPortrait;
+ (UIEdgeInsets)safeAreaForLandscape;

//1.18适配iPhone X临时使用
+ (CGFloat)safeAreaBottomLittleTemp;

//计算功能按钮的位置
+(float)measureToolBarFrameOriginX:(float)index;

@end

#define SCREEN_WIDTH  [PLUtilUIScreen screenWidth]
#define SCREEN_HEIGHT [PLUtilUIScreen screenHeight]
#define STATUSBAR_HEIGHT [PLUtilUIScreen statusBarHeight]
#define NAVIGATIONBAR_HEIGHT [PLUtilUIScreen navigationBarHeight]
#define TOOLBAR_HEIGHT [PLUtilUIScreen toolBarHeight]
#define fitWidthBy6(value) [PLUtilUIScreen fitWidthBy6:(value)]
#define fitHeightBy6(value) [PLUtilUIScreen fitHeightBy6:(value)]
#define fitFontBy6(value) [PLUtilUIScreen fitFontBy6:(value)]
//横屏
#define SCREEN_WIDTH_ORI  [PLUtilUIScreen screenWidthOri]
#define SCREEN_HEIGHT_ORI [PLUtilUIScreen screenHeightOri]

//iPhoneX适配
#define IS_IPHONEX [PLUtilUIScreen isiPhoneX]
#define SAFEAREA_INSET_TOP  ([PLUtilUIScreen safeAreaForPortrait].top)
#define SAFEAREA_INSET_LEFT  ([PLUtilUIScreen safeAreaForPortrait].left)
#define SAFEAREA_INSET_BOTTOM  ([PLUtilUIScreen safeAreaForPortrait].bottom)
#define SAFEAREA_INSET_RIGHT  ([PLUtilUIScreen safeAreaForPortrait].right)

#define LANDSCAPE_SAFEAREA_INSET_TOP  ([PLUtilUIScreen safeAreaForLandscape].top)
#define LANDSCAPE_SAFEAREA_INSET_LEFT  ([PLUtilUIScreen safeAreaForLandscape].left)
#define LANDSCAPE_SAFEAREA_INSET_BOTTOM  ([PLUtilUIScreen safeAreaForLandscape].bottom)
#define LANDSCAPE_SAFEAREA_INSET_RIGHT  ([PLUtilUIScreen safeAreaForLandscape].right)

//1.18适配iPhone X临时使用
#define SAFEAREA_INSET_BOTTOM_LITTLE ([PLUtilUIScreen safeAreaBottomLittleTemp])

//导航条
#define NAVIGATIONBAR_LEFT_OFFSET 5
#define NAVIGATIONBAR_RIGHT_OFFSET 15

//屏幕大小适配
#define V_ZOOM(height)          ((SCREEN_HEIGHT >= 667) ? height : floor(height * SCREEN_HEIGHT / 667.0f))
