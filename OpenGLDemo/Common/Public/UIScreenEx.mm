
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIScreenEx"
#pragma clang diagnostic pop

//
//  UIScreenEx.cpp
//  baseUI
//
//  Created by odie song on 12-9-13.
//  Copyright (c) 2012年 odie song. All rights reserved.
//

#include "UIScreenEx.h"
#import "UIDevice+hw.h"

#define iPhone6PlusPXWidth (414)

static int static_statusbarHeight = 0;

int getScreenWidth()
{
     static int s_scrWidth = 0;
    if (s_scrWidth == 0){
        UIScreen* screen = [UIScreen mainScreen];
        CGRect screenFrame = screen.bounds;
        s_scrWidth = MIN(screenFrame.size.width, screenFrame.size.height);
        
        //解决在ipad中app启动时[UIScreen mainScreen].CZ_B_SizeW于768px的问题
        if (s_scrWidth >= 768) {
            s_scrWidth = 320 * (s_scrWidth / 768.0f);
        }
    }
    
    return s_scrWidth;
}

int getScreenHeight()
{
    static int s_scrHeight = 0;
    if (s_scrHeight == 0){
        UIScreen* screen = [UIScreen mainScreen];
        CGRect screenFrame = screen.bounds;
        s_scrHeight = MAX(screenFrame.size.height, screenFrame.size.width);
        
        //解决在ipad中app启动时[UIScreen mainScreen].CZ_B_SizeH于1024x的问题
        if (s_scrHeight >= 1024) {
            s_scrHeight = 480 * (s_scrHeight / 1024.0f);
        }
    }
    return s_scrHeight;
}

int getScreenScale()
{
    static int scale = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    
    return scale;
}

CGRect getScreenBounds()
{
    return [UIScreen mainScreen].bounds;
}

CGSize getScreenSize()
{
    return [UIScreen mainScreen].bounds.size;
}


//int getStatusBarHeight()
//{
//    if (static_statusbarHeight == 0) {
//        CGRect statusBarFrame = kCZUIApplication.statusBarFrame;
//        static_statusbarHeight = MIN(statusBarFrame.size.width, statusBarFrame.size.height);
//    }
//    return static_statusbarHeight;
//}

void setStatusBarHeight(int newH)
{
    static_statusbarHeight = newH;
}

//以iPhone5s屏幕宽度为基准
CGFloat fitScreenW(CGFloat value)
{
    CGFloat tValue = value;
    int rValue =(tValue/320.0f)*getScreenWidth();
    return rValue;
}

//以iPhone6屏幕宽度为基准
CGFloat fitScreenWidthBy6(CGFloat value)
{
    return (value/375.0f)*getScreenWidth();
}
//以iPhone6屏幕宽度为基准适配更小的屏幕
CGFloat fitSmallScreenWidthBy6(CGFloat value)
{
    return (getScreenWidth()<375.0f) ? (value/375.0f)*getScreenWidth() : value;
}
//以iPhone6屏幕高度为基准
CGFloat fitScreenHeightBy6(CGFloat value)
{
    CGFloat safeHeight = getScreenHeight() - homeIndicatorHeight();
    return (value/667.0f)*safeHeight;
}

CGFloat fitScaleScreenBy6(CGFloat value)
{
#ifndef OPEN_AUTO_SCALE
    return value;
#else
    return value*MAX(1.0f, screenScale());
#endif
}

CGFloat fitScaleFont(CGFloat value)
{
    
#ifndef OPEN_AUTO_SCALE
    if(iPhone6PlusPXWidth > getScreenWidth()) return value;
    CGFloat tValue = value;
    CGFloat rValue =ceilf(tValue*(1.0588f));
    return rValue;
#else
    CGFloat tValue = value;
    CGFloat rValue =tValue*(screenScale());
    return rValue;
#endif
    
}
//设计不支持屏幕比例缩放字号
CGFloat fontfitScreenWidthBy6(CGFloat value)
{//字号沿用之前逻辑
    CGFloat tValue = value;
    int rValue =(tValue/375.0f)*getScreenWidth();
    CGFloat retValue = fitScaleFontScreen(rValue);
    
//    UIDevicePlatform deviceType = (UIDevicePlatform)[[UIDevice currentDevice] platformType];
//
//    if (deviceType >= UIDevice1GiPhone && deviceType <= UIDevice5SiPhone) {
//        retValue = fitScaleFont(value);
//    }
//    else {
//        retValue = fitScaleFont((value/375.0f)*getScreenWidth());
//    }
//    
    return retValue;
}

BOOL is3XScreen() {
    if ([[UIDevice currentDevice] platformType] == UIDevice6Plus    ||
        [[UIDevice currentDevice] platformType] == UIDevice6SPlus   ||
        [[UIDevice currentDevice] platformType] == UIDevice7Plus    ||
        [[UIDevice currentDevice] platformType] == UIDevice8Plus
        ) {
        return YES;
    }
    
    return NO;
}

//CGFloat getPTbyPX(CGFloat value) {
//    if (is3XScreen()) {
//        return value/3;
//    }
//    else {
//        return value/retinaScale;
//    }
//}

CGFloat fitScreenH(CGFloat value)
{
#ifndef OPEN_AUTO_SCALE
    return value;
#else
    return value*MAX(1.0f,screenScale());
#endif
}

CGFloat fitScaleScreen(CGFloat value)
{
#ifndef OPEN_AUTO_SCALE
    return value;
#else
    return value*MAX(1.0f,screenScale());
#endif

}

CGFloat fitScaleFontScreen(CGFloat value)
{

#ifndef OPEN_AUTO_SCALE
    if(iPhone6PlusPXWidth > getScreenWidth()) return value;
    CGFloat tValue = value;
    int rValue =ceilf(tValue*(1.0588f));
    return rValue;
#else
    CGFloat tValue = value;
    int rValue =tValue*(screenScale());
    return rValue;
#endif
    
}

CGFloat screenScale()
{
    return 3.0f;
    
//#ifndef OPEN_AUTO_SCALE
//    return 1.0f;
//#else
//
//    return [[QQDynamicFontManager GetInstances] dynamicFontScale];
//#endif
}

CGFloat screenFontSize()
{
    //设计师rachel说不再需要32号的字
//     if(320 == getScreenWidth()) return 16.0f*screenScale();
    return 17.0f*screenScale();
}

CGFloat screeniPhone6PlusScale(CGFloat value, CGFloat replaceValue)
{
    if(iPhone6PlusPXWidth > getScreenWidth()) return value;
    return ceilf(replaceValue);
}

CGFloat controllerToolbarHeight(void)
{
    CGFloat height = 49 + homeIndicatorHeight();
    return height;
}

CGFloat homeProEditHeight(void)
{
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        if (UIDeviceXiPhone == [[UIDevice currentDevice] platformType]) {
            height = 39 + homeIndicatorHeight();
        }
    }
    return height;
}

CGFloat homeIndicatorHeight(void)
{
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height += [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

CGFloat safeAreaInsetsTop(void)
{
    CGFloat inset = 0;
    if (@available(iOS 11.0, *)) {
        inset += [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
    }
    return inset;
}

CGFloat safeAreaInsetsLeft(void)
{
    CGFloat inset = 0;
    if (@available(iOS 11.0, *)) {
        inset += [UIApplication sharedApplication].delegate.window.safeAreaInsets.left;
    }
    return inset;
}

CGFloat safeAreaInsetsRight(void)
{
    CGFloat inset = 0;
    if (@available(iOS 11.0, *)) {
        inset += [UIApplication sharedApplication].delegate.window.safeAreaInsets.right;
    }
    return inset;
}

@implementation UIScreen (externForFK)
+ (CGFloat)adjustWidth:(CGFloat)value {
    return _size_W(value);
}

+ (CGFloat)adjustHeight:(CGFloat)value {
    return _size_H(value);
}

+ (CGFloat)adjustSize:(CGFloat)value {
    return _size_S(value);
}
+ (CGFloat)getScreenWidth{
    return SCREEN_WIDTH;
}
+ (CGFloat)getScreenHeight{
    return SCREEN_HEIGHT;
}
+ (CGFloat)adjustWidthBy6:(CGFloat)value {
    return _size_W_6(value);
}

+ (CGFloat)adjustHeightBy6:(CGFloat)value {
    return _size_H_6(value);
}

+ (CGFloat)adjustFontSizeBy6:(CGFloat)value {
    return _size_F_6(value);
}

//+ (CGFloat)getStatusBarHeight {
//    return getStatusBarHeight();
//}

@end


@implementation UIFont(fontEX)

//+ (UIFont*)boldSystemFontScreenOfSize:(CGFloat)fontSize
//{
//    //http://tapd.oa.com/IosQQ/bugtrace/bugs/view?bug_id=1010066451053631169&url_cache_key=919be88bedc5a408c2714d4830865ba2 -- cocozzhang 等待做优化
//    //用ALT+鼠标进来这里的人,麻烦直接用下面的方法CZ_NewSystemFontOfSize(fontSize)替代boldSystemFontScreenOfSize:fontSize
//    return CZ_NewSystemFontOfSize(fontSize);
//    
//}

+ (UIFont *)fontWithUnreliableName:(NSString *)fName size:(CGFloat)fSize
{
    UIFont *f = [UIFont fontWithName:fName size:fSize];
    
    if (!f) {
        f = [UIFont systemFontOfSize:fSize];
    }
    
    return f;
}

@end
