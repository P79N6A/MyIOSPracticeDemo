//
//  HYUIScreenHelper.m
//  HuaYang
//
//  Created by 张晏兵 on 14-10-11.
//  Copyright (c) 2014年 tencent. All rights reserved.
//

#import "PLUtilUIScreen.h"
#import "UIDevice+Hardware.h"

#define iPhone6PlusPXWidth (414)

@implementation PLUtilUIScreen

+ (int)screenWidth
{
    static int s_scrWidth = 0;
    if (s_scrWidth == 0)
    {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        s_scrWidth = MIN(screenFrame.size.width, screenFrame.size.height);
    }
    return s_scrWidth;
}

+ (int)screenHeight
{
    static int s_scrHeight = 0;
    if (s_scrHeight == 0)
    {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        s_scrHeight = MAX(screenFrame.size.width, screenFrame.size.height);
    }
    return s_scrHeight;
}

+ (int)statusBarHeight
{
    if ([self isiPhoneX]) {
        return 44;
    }
    return 20;
}

+ (int)navigationBarHeight
{
    return 44;
}

+ (int)toolBarHeight
{
    return 49;
}
+ (int)topBarHeight
{
    return [self statusBarHeight] + [self navigationBarHeight];
}
+ (BOOL)ptInRect:(CGPoint)point rect:(CGRect)rect
{
    if (point.x >= rect.origin.x &&
        point.x < (rect.origin.x + rect.size.width) &&
        point.y >= rect.origin.y &&
        point.y < (rect.origin.y + rect.size.height))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (CGFloat)fitFontBy6:(CGFloat)value
{
    CGFloat screenWidth_6 = 375.0;
    CGFloat screenWidth = [self screenWidth];
    return (value * screenWidth) / screenWidth_6;
}

+ (CGFloat)fitWidthBy6:(CGFloat)value
{
    CGFloat screenWidth_6 = 375.0;
    CGFloat screenWidth = [self screenWidth];
    return (value * screenWidth) / screenWidth_6;
}

+ (CGFloat)fitHeightBy6:(CGFloat)value
{
    CGFloat screenHeight_6 = 667.0;
    CGFloat screenHeight = [self screenHeight];
    return (value * screenHeight) / screenHeight_6;
}

+ (CGRect)rectWithInset:(CGRect)rect inset:(UIEdgeInsets)insets
{
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                      rect.size.width - (insets.left + insets.right),
                      rect.size.height - (insets.top + insets.bottom));
}

//支持横屏 add by luczhong
+ (int)screenWidthOri
{
    static int s_scrWidth = 0;
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation interfaceOrientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        //横屏
        s_scrWidth = MAX(screenFrame.size.width, screenFrame.size.height);
    }
    else {
        s_scrWidth = MIN(screenFrame.size.width, screenFrame.size.height);
    }
    
    return s_scrWidth;
}

+ (int)screenHeightOri
{
    static int s_scrHeight = 0;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation interfaceOrientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        //横屏
        s_scrHeight = MIN(screenFrame.size.width, screenFrame.size.height);
    }
    else {
        s_scrHeight = MAX(screenFrame.size.width, screenFrame.size.height);
    }
    
    return s_scrHeight;
}

+ (BOOL)isiPhoneX
{
    NSString *platform = [[UIDevice currentDevice] platform];
    if ([platform isEqualToString:@"iPhone10,3"]
        || [platform isEqualToString:@"iPhone10,6"]
        || ([platform isEqualToString:@"x86_64"] && 375 == [self screenWidth] && 812 == [self screenHeight])) {
        return YES;
    }
    return NO;
}

+ (UIEdgeInsets)safeAreaForPortrait
{
    if ([self isiPhoneX]) {
        return UIEdgeInsetsMake(44, 0, 34, 0);
    }
    return UIEdgeInsetsZero;
}

+ (UIEdgeInsets)safeAreaForLandscape
{
    if ([self isiPhoneX]) {
        return UIEdgeInsetsMake(0, 44, 21, 44);
    }
    return UIEdgeInsetsZero;
}

+ (CGFloat)safeAreaBottomLittleTemp
{
    if ([self isiPhoneX]) {
        return 8.0f;
    }
    return 0.0f;
}

+(float)measureToolBarFrameOriginX:(float)btnIndex
{
    float btnSize = 36;
    float btnCount = 7.0;
    float originX = 0;
    if (SCREEN_WIDTH <= 320) {
        float margin = 6;
        originX = margin * (btnIndex + 1) + btnSize * btnIndex;
    } else {
        float margin = 10;
        float width = (SCREEN_WIDTH - 2 * margin - btnSize * btnCount) / (btnCount- 1.0);
        originX = width * btnIndex + margin + btnSize * btnIndex;
    }

    return originX;
}
+ (bool)isiPhone5 {
    return ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON );
}

@end

