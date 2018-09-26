//
//  UIScreenEx.h
//  baseUI
//
//  Created by odie song on 12-9-13.
//  Copyright (c) 2012年 odie song. All rights reserved.
//

#ifndef __baseUI__UIScreenEx__
#define __baseUI__UIScreenEx__

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
    int getScreenWidth();
    
    int getScreenHeight();
    
    int getScreenScale(void);
    
    CGRect getScreenBounds(void);
    
    CGSize getScreenSize(void);
    
    // 获取状态栏竖边高度
    int getStatusBarHeight();
    
    void setStatusBarHeight(int newH);
    
    CGFloat fitScreenW(CGFloat value);
    CGFloat fitScreenWidthBy6(CGFloat value);
    CGFloat fitSmallScreenWidthBy6(CGFloat value);
    CGFloat fitScreenHeightBy6(CGFloat value);
    CGFloat fitScaleScreenBy6(CGFloat value);
    CGFloat fontfitScreenWidthBy6(CGFloat value);
    BOOL    is3XScreen();
    CGFloat getPTbyPX(CGFloat value);
    CGFloat fitScreenH(CGFloat value);
    CGFloat fitScaleScreen(CGFloat value);
    CGFloat fitScaleFontScreen(CGFloat value);
    CGFloat screenScale();
    CGFloat screenFontSize();
    CGFloat screeniPhone6PlusScale(CGFloat value, CGFloat replaceValue);
    CGFloat controllerToolbarHeight(void);
    CGFloat homeIndicatorHeight(void);
    CGFloat safeAreaInsetsTop(void);
    CGFloat safeAreaInsetsLeft(void);
    CGFloat safeAreaInsetsRight(void);
    CGFloat homeProEditHeight(void);
    
#ifdef __cplusplus
}
#endif

#define SCREEN_WIDTH            getScreenWidth()
#define SCREEN_HEIGHT           getScreenHeight()
#define SCREEN_WIDTH_2          (SCREEN_WIDTH << 1)
#define SCREEN_HEIGHT_2         (SCREEN_HEIGHT << 1)
#define HOME_INDICATOR_HEIHT    homeIndicatorHeight()
#define SAFE_AREA_INSET_TOP     safeAreaInsetsTop()      // 安全区域top inset(横竖屏不一样)
#define SAFE_AREA_INSET_LEFT    safeAreaInsetsLeft()    // 安全区域left inset
#define SAFE_AREA_INSET_RIGHT   safeAreaInsetsRight()   // 安全区域right inset
#define HOME_PROEDIT_HEIGHT     homeProEditHeight()    //挂件列表相关位移

/**返回float*/
#define OPEN_AUTO_SCALE
#define _size_W(value)    fitScreenW(value)
#define _size_H(value)    fitScreenH(value)
#define _size_S(value)    fitScaleScreen(value)
#define _size_F(value)    fitScaleFontScreen(value)        //note by erwinkuang:手机系统设置字号缩放
#define _sizeScale        screenScale()

#define _size_W_6(value)  fitScreenWidthBy6(value)              //add by erwinkuang
#define _size_H_6(value)  fitScreenHeightBy6(value)
#define _size_S_6(value)  fitScaleScreenBy6(value)
#define _size_F_6(value)  fontfitScreenWidthBy6(value)          //add by erwinkuang：屏幕适配字号，设计提出：不按屏幕比例缩放 字号，故内部实现直接返回fitScaleFontScreen(value);
#define _getPTbyPX(value) getPTbyPX(value)                      //px转pt

#define _size_S_W_6(value) fitSmallScreenWidthBy6(value)   //nicohuang，设计要小屏幕单独适配 WTF!!!
//针对AIO当前切换字体时候自动退出方案做处理添加方案切换宏方便后面及时改动
//#define OPEN_AIO_AUTO_SCALE

// 这是竖屏的
#define APPLICATION_FRAME_WIDTH       ([UIScreen mainScreen].applicationFrame.size.width)
#define APPLICATION_FRAME_HEIGHT      ([UIScreen mainScreen].applicationFrame.size.height)

#define STATUSBAR_HEIGHT        getStatusBarHeight()
#define APPLICATION_WIDTH       (SCREEN_WIDTH)
#define APPLICATION_HEIGHT      (SCREEN_HEIGHT - STATUSBAR_HEIGHT)

#ifndef IS_IPHONE5
#define IS_IPHONE5   (SCREEN_HEIGHT > 480 ? TRUE:FALSE)
#endif

#ifndef IS_BIGGER_THEN_IPHONE_6
#define IS_BIGGER_THEN_IPHONE_6 (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) >= 667.0)
#endif

#ifndef IS_IPHONE_6P
#define IS_IPHONE_6P (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 736.0)
#endif

#ifndef IS_3X_SCREEN
#define IS_3X_SCREEN is3XScreen()
#endif

#define FontScreenSize screenFontSize()
#define PLUSSCALE(value,replaceValue) screeniPhone6PlusScale(value,replaceValue)

#endif /* defined(__baseUI__UIScreenEx__) */


@interface UIScreen     (externForFK)

+ (CGFloat)adjustWidth:(CGFloat)value;
+ (CGFloat)adjustHeight:(CGFloat)value;
+ (CGFloat)adjustSize:(CGFloat)value;
+ (CGFloat)adjustWidthBy6:(CGFloat)value;
+ (CGFloat)adjustHeightBy6:(CGFloat)value;
+ (CGFloat)adjustFontSizeBy6:(CGFloat)value;
+ (CGFloat)getStatusBarHeight;
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;
@end

/****************
 iPhone6 plus 字体放大统一调整，使用动态替换利用分辨率判断输出
 ***************/

@interface UIFont(fontEX)

/**
 对iPhone6 & iPhone Plus 一级页面字体做单独适配
 */
+ (UIFont*)boldSystemFontScreenOfSize:(CGFloat)fontSize;

/**
 * @brief 根据字体名称返回字体，如无对应字体，返回系统默认字体
 * @param fName 字体名称
 * @param fSize 字体大小
 */
+ (UIFont *)fontWithUnreliableName:(NSString *)fName size:(CGFloat)fSize;
@end

#pragma mark 字体样式

#define QUI_TITLE_FONT_SIZE                 (SCREEN_WIDTH>320 ? (18):(17))                         //标题字号
#define QUI_TITLE_FONT_SIZE_SCALE           (SCREEN_WIDTH>320 ? (_size_F(18)):(_size_F(17)))       //标题字号（适配字号）

#define QUI_SUMMARY_FONT_SIZE               (14)                //摘要字号
#define QUI_SUMMARY_FONT_SIZE_SCALE         (_size_F(14))       //摘要字号（适配字号）

#define QUI_SECONDARY_FONT_SIZE             (12)                //次要信息字号
#define QUI_SECONDARY_FONT_SIZE_SCALE       (_size_F(12))       //次要信息字号（适配字号）

#define QUI_SMALL_BUTTON_FONT_SIZE          (14)                //小按钮字号
#define QUI_SMALL_BUTTON_FONT_SIZE_SCALE    (_size_F(14))       //小按钮字号（适配字号）

#pragma mark 表单样式
//其他view
#define QUI_HEIGHT_FOR_HEADER_VIEW          (_size_S(30))       //height for head view（有字的）
#define QUI_HEIGHT_FOR_FIRST_HEADER_VIEW    (_size_S(46))       //height for first head view
#define QUI_HEIGHT_FOR_SECOND_HEADER_VIEW    (_size_S(20))       //height for second head view
#define QUI_HEIGHT_FOR_MORE_VIEW            (_size_S(50))       //height for more view (eg.全局搜索->查看更多)
#define QUI_HEIGHT_FOR_SECTION_GAP          20                  //比如设置里的group和group间隙


#define QUI_MARGIN_IN_HEADER_FOOTER_SHORT   (_size_S(8))        //short margin in header and footer(eg.群消息设置->“接收消息并提醒的群”)
#define QUI_MARGIN_IN_HEADER_FOOTER_LONG    (_size_S(20))       //long margin in header and footer
#define QUI_HEIGHT_FOR_HEADER_FOOTER        (CZ_NewSystemFontOfSize(QUI_SUMMARY_FONT_SIZE_SCALE).lineHeight + QUI_MARGIN_IN_HEADER_FOOTER_SHORT + QUI_MARGIN_IN_HEADER_FOOTER_LONG)                           //height for header and footer
#define QUI_MARGIN_IN_HEADER_FOOTER_OFFSET  (_size_S(12))       //UIView+Global 里面announceHeaderView上下都是8(short)空隙，还差12空隙达到20(long)

#define QUI_TABLEVIEW_EDITING_SEPARATOR_START_X 50              //编辑状态下的分割线开始x(eg.特别关心->管理)

//单行样式
#define QUI_SINGLE_LINE_LEFT_MARGIN         (12)                //cell左边距
#define QUI_SINGLE_LINE_RIGHT_MARGIN        (12)                //cell右边距
#define QUI_SINGLE_LINE_TOP_MARGIN          (8)                 //cell上边距
#define QUI_SINGLE_LINE_BOTTOM_MARGIN       (8)                 //cell下边距
#define QUI_SINGLE_LINE_TOP_MARGIN_SCALE    (QUI_SINGLE_LINE_HEIGHT_SCALE - QUI_SINGLE_LINE_ICON_WIDTH_SCALE) / 2       //cell上边距（适配字号）
#define QUI_SINGLE_LINE_BOTTOM_MARGIN_SCALE (_size_S(8))        //cell下边距（适配字号）
#define QUI_SINGLE_LINE_ICON_RIGHT_MARGIN   (12)                //icon的右边距
#define QUI_SINGLE_LINE_ICON_WIDTH          (34)                //icon边宽
#define QUI_SINGLE_LINE_ICON_WIDTH_SCALE    (_size_S(34))       //icon边宽（适配字号）
#define QUI_SINGLE_LINE_HEIGHT              (46)                //cell高
#define QUI_SINGLE_LINE_HEIGHT_SCALE        (_size_S(46))       //cell高（适配字号）
#define QUI_SINGLE_LINE_ICON_LEFT_MARGIN    (8)                 //icon左边距（当icon左边有checkbox时的边距）
#define QUI_SINGLE_LINE_INDICATOR_LEFT_MARGIN (8)               //箭头左边距（箭头左边有detailText时的边距）

//效率型双行样式
#define QUI_EFFIC_DOUBLE_LINE_LEFT_MARGIN   (12)                //cell左边距
#define QUI_EFFIC_DOUBLE_LINE_RIGHT_MARGIN  (12)                //cell右边距
#define QUI_EFFIC_DOUBLE_LINE_TOP_MARGIN    (8)                 //cell上边距
#define QUI_EFFIC_DOUBLE_LINE_BOTTOM_MARGIN (8)                 //cell下边距
#define QUI_EFFIC_DOUBLE_LINE_TOP_MARGIN_SCALE (_size_S(8))     //cell上边距（适配字号）
#define QUI_EFFIC_DOUBLE_LINE_BOTTOM_MARGIN_SCALE (_size_S(8))  //cell下边距（适配字号）
#define QUI_EFFIC_DOUBLE_LINE_ICON_RIGHT_MARGIN (12)            //icon的右边距
#define QUI_EFFIC_DOUBLE_LINE_ICON_WIDTH    (40)                //icon边宽
#define QUI_EFFIC_DOUBLE_LINE_ICON_WIDTH_SCALE (_size_S(40))    //icon边宽（适配字号）
#define QUI_EFFIC_DOUBLE_LINE_TEXT_GAP_V    (3)                 //行垂直间距
#define QUI_EFFIC_DOUBLE_LINE_TEXT_GAP_V_SCALE (_size_S(3))     //行垂直间距（适配字号）
#define QUI_EFFIC_DOUBLE_LINE_HEIGHT        (56)                //cell高
#define QUI_EFFIC_DOUBLE_LINE_HEIGHT_SCALE  (_size_S(56))       //cell高（适配字号）
#define QUI_EFFIC_DOUBLE_LINE_SEPARATOR_START_X (QUI_EFFIC_DOUBLE_LINE_LEFT_MARGIN + QUI_EFFIC_DOUBLE_LINE_ICON_WIDTH_SCALE + QUI_EFFIC_DOUBLE_LINE_ICON_RIGHT_MARGIN)                    //分割线开始x

//双行样式
#define QUI_DOUBLE_LINE_LEFT_MARGIN         (12)                //cell左边距
#define QUI_DOUBLE_LINE_RIGHT_MARGIN        (12)                //cell右边距
#define QUI_DOUBLE_LINE_TOP_MARGIN          (8)                 //cell上边距
#define QUI_DOUBLE_LINE_BOTTOM_MARGIN       (8)                 //cell下边距
#define QUI_DOUBLE_LINE_TOP_MARGIN_SCALE    (_size_S(8))        //cell上边距（适配字号）
#define QUI_DOUBLE_LINE_BOTTOM_MARGIN_SCALE (_size_S(8))        //cell下边距（适配字号）
#define QUI_DOUBLE_LINE_ICON_RIGHT_MARGIN   (12)                //icon的右边距
#define QUI_DOUBLE_LINE_ICON_WIDTH          (50)                //icon边宽
#define QUI_DOUBLE_LINE_ICON_WIDTH_SCALE    (_size_S(50))       //icon边宽（适配字号）
#define QUI_DOUBLE_LINE_TEXT_GAP_V          (3)                 //行垂直间距
#define QUI_DOUBLE_LINE_TEXT_GAP_V_SCALE    (_size_S(3))        //行垂直间距（适配字号）
#define QUI_DOUBLE_LINE_HEIGHT              (66)                //cell高
#define QUI_DOUBLE_LINE_HEIGHT_SCALE        (_size_S(66))       //cell高（适配字号）

//双行样式（icon的高度与cell相同的样式）
#define QUI_DOUBLE_LINE_1_LEFT_MARGIN       (0)                 //cell左边距
#define QUI_DOUBLE_LINE_1_RIGHT_MARGIN      (12)                //cell右边距
#define QUI_DOUBLE_LINE_1_ICON_RIGHT_MARGIN (12)                //icon的右边距
#define QUI_DOUBLE_LINE_1_HEIGHT            (74)                //cell高
#define QUI_DOUBLE_LINE_1_HEIGHT_SCALE      (_size_S(74))       //cell高（适配字号）
#define QUI_DOUBLE_LINE_1_ICON_WIDTH        (74)                //icon边宽
#define QUI_DOUBLE_LINE_1_ICON_WIDTH_SCALE  (_size_S(74))       //icon边宽（适配字号）
#define QUI_DOUBLE_LINE_1_TEXT_GAP_V        (3)                 //行垂直间距
#define QUI_DOUBLE_LINE_1_TEXT_GAP_V_SCALE  (_size_S(3))        //行垂直间距（适配字号）

//多行样式
#define QUI_MUTILE_LINE_LEFT_MARGIN         (12)                //cell左边距
#define QUI_MUTILE_LINE_RIGHT_MARGIN        (12)                //cell右边距
#define QUI_MUTILE_LINE_TOP_MARGIN          (8)                 //cell上边距
#define QUI_MUTILE_LINE_BOTTOM_MARGIN       (8)                 //cell下边距
#define QUI_MUTILE_LINE_TOP_MARGIN_SCALE    (_size_S(9))        //cell上边距（适配字号）
#define QUI_MUTILE_LINE_BOTTOM_MARGIN_SCALE (_size_S(12))       //cell下边距（适配字号）
#define QUI_MUTILE_LINE_ICON_RIGHT_MARGIN   (12)                //icon的右边距
#define QUI_MUTILE_LINE_HEIGHT              (86)                //cell高
#define QUI_MUTILE_LINE_HEIGHT_SCALE        (_size_S(86))       //cell高（适配字号）
#define QUI_MUTILE_LINE_ICON_WIDTH          (70)                //icon边宽
#define QUI_MUTILE_LINE_ICON_WIDTH_SCALE    (_size_S(70))       //icon边宽（适配字号）
#define QUI_MUTILE_LINE_TEXT_GAP_V          (3)                 //行垂直间距
#define QUI_MUTILE_LINE_TEXT_GAP_V_SCALE    (_size_S(3))        //行垂直间距（适配字号）
#define QUI_MUTILE_LINE_SEPARATOR_START_X   (QUI_MUTILE_LINE_LEFT_MARGIN + QUI_MUTILE_LINE_ICON_WIDTH_SCALE + QUI_MUTILE_LINE_ICON_RIGHT_MARGIN)                          //分割线开始x

//多行样式（icon的高度与cell相同的样式）
#define QUI_MUTILE_LINE_1_LEFT_MARGIN       (0)                 //cell左边距
#define QUI_MUTILE_LINE_1_RIGHT_MARGIN      (12)                //cell右边距
#define QUI_MUTILE_LINE_1_ICON_RIGHT_MARGIN (12)                //icon的右边距
#define QUI_MUTILE_LINE_1_HEIGHT            (94)                //cell高
#define QUI_MUTILE_LINE_1_HEIGHT_SCALE      (_size_S(94))       //cell高（适配字号）
#define QUI_MUTILE_LINE_1_ICON_WIDTH        (94)                //icon边宽
#define QUI_MUTILE_LINE_1_ICON_WIDTH_SCALE  (_size_S(94))       //icon边宽（适配字号）
#define QUI_MUTILE_LINE_1_TEXT_GAP_V        (3)                 //行垂直间距
#define QUI_MUTILE_LINE_1_TEXT_GAP_V_SCALE  (_size_S(3))        //行垂直间距（适配字号）

//视屏类的多行样式
#define QUI_MUTILE_LINE_VIDEO_LEFT_MARGIN   (0)                 //cell左边距
#define QUI_MUTILE_LINE_VIDEO_RIGHT_MARGIN  (12)                //cell右边距
#define QUI_MUTILE_LINE_VIDEO_ICON_RIGHT_MARGIN (12)            //icon的右边距
#define QUI_MUTILE_LINE_VIDEO_HEIGHT        (94)                //cell高
#define QUI_MUTILE_LINE_VIDEO_HEIGHT_SCALE  (_size_S(94))       //cell高（适配字号）
#define QUI_MUTILE_LINE_VIDEO_ICON_WIDTH    (94)                //icon边宽
#define QUI_MUTILE_LINE_VIDEO_ICON_WIDTH_SCALE (_size_S(94))    //icon边宽（适配字号）
#define QUI_MUTILE_LINE_VIDEO_TEXT_GAP_V    (3)                 //行垂直间距
#define QUI_MUTILE_LINE_VIDEO_TEXT_GAP_V_SCALE (_size_S(3))     //行垂直间距（适配字号）

//书籍类的多行样式
#define QUI_MUTILE_LINE_BOOK_LEFT_MARGIN    (0)                 //cell左边距
#define QUI_MUTILE_LINE_BOOK_RIGHT_MARGIN   (12)                //cell右边距
#define QUI_MUTILE_LINE_BOOK_ICON_RIGHT_MARGIN (12)             //icon的右边距
#define QUI_MUTILE_LINE_BOOK_HEIGHT         (94)                //cell高
#define QUI_MUTILE_LINE_BOOK_HEIGHT_SCALE   (_size_S(94))       //cell高（适配字号）
#define QUI_MUTILE_LINE_BOOK_ICON_WIDTH     (94)                //icon边宽
#define QUI_MUTILE_LINE_BOOK_ICON_WIDTH_SCALE (_size_S(94))     //icon边宽（适配字号）
#define QUI_MUTILE_LINE_BOOK_TEXT_GAP_V     (3)                 //行垂直间距
#define QUI_MUTILE_LINE_BOOK_TEXT_GAP_V_SCALE (_size_S(3))      //行垂直间距（适配字号）

#pragma mark 按钮样式
//大按钮样式（N=4）
#define QUI_BIG_BUTTON_HEIGHT               (_size_S(40))       //大按钮高度：80px
#define QUI_BIG_BUTTON_MARGIN_LEFT_RIGHT    (12)                //大按钮左右边距：6N
#define QUI_BIG_BUTTON_MARGIN_TOP_BOTTOM    (8)                 //大按钮上下边距：4N
#define QUI_BIG_BUTTON_MARGIN_GAP_5N        (10)                //大按钮之间间隙1：5N（三个按钮之间）
#define QUI_BIG_BUTTON_MARGIN_GAP_6N        (12)                //大按钮之间间隙2：6N（两个按钮之间）
#define QUI_BIG_BUTTON_MARGIN_TOP_TABLEVIEW (24)                //大按钮跟随表单间距：12N
#define QUI_BIG_BUTTON_MARGIN_TOP_TIPS      (36)                //大按钮跟随辅助文字间距：18N
#define QUI_BIG_BUTTON_MARGIN_BOTTOM_TIPS   (8)                 //大按钮距离下方辅助文字：4N
#define QUI_BIG_BUTTON_WIDTH                (SCREEN_WIDTH - QUI_BIG_BUTTON_MARGIN_LEFT_RIGHT*2)     //大按钮宽度：W - 12N

//中按钮样式
#define QUI_MIDDLE_BUTTON_WIDTH             (QUI_BIG_BUTTON_WIDTH * 2/3)                            //中按钮宽度：大按钮2/3
#define QUI_MIDDLE_BUTTON_MARGIN_LEFT_RIGHT ((SCREEN_WIDTH - QUI_MIDDLE_BUTTON_WIDTH)/2)            //中按钮左右边距：(屏幕宽 - 中按钮宽)/2

//小按钮样式
#define QUI_SMALL_BUTTON_WIDTH_SCALE        (_size_S(64))       //小按钮宽度：2字宽+34px*2
#define QUI_SMALL_BUTTON_HEIGHT             (30)                //小按钮高度：60px
#define QUI_SMALL_BUTTON_HEIGHT_SCALE       (_size_S(30))       //小按钮高度：60px(适配字号)
#define QUI_SMALL_BUTTON_MARGIN_RIGHT       (_size_S(12))       //小按钮右边距：6N

//小按钮 宽度不适配，边距不适配字体
#define QUI_SMALL_BUTTON_WIDTH_NO_SCALE              (60)                  //小按钮宽度：2字宽+34px*2
#define QUI_SMALL_BUTTON_MARGIN_RIGHT_NO_SCALE       (_size_W_6(12))       //小按钮右边距：6N
