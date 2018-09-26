//
//  ODFaceboardViewController.m
//  HuaYang
//
//  Created by johnxguo on 2017/5/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

// johnxguo OCS file mark

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODFaceboardViewController.h"
#import "ODFaces.h"
#import "UIImage+ODHelper.h"
#import "ODCommonUIDef.h"
#import "UIView+BTPosition.h"
#import "ODOCSUtil.h"
#import "UIScreenEx.h"


#define safe_call(x, y, z) \
if (x && [x respondsToSelector:@selector(y)]) { \
[x y z]; \
} \

#if ENABLE_OCS_DYNAMIC_CLASS
@interface ODFaceboardViewController()
    <UIGestureRecognizerDelegate,
     UIScrollViewDelegate> {
         
    UIScrollView *_scrollView;
    UIPageControl *_pageCtl;
    UIButton *_sendButton;
}

@end

@implementation ODFaceboardViewController {
    int lineSpacing;
    int cellWidth;
    int lineCell;
    int pageCell;
    int pageLine;
    int lrMargin;
    int tbMargin;
    int count;
    int rmBtnWidth;
    int rmBtnHeight;
    int fbWidth;
    int fbHeight;
    int boxHeight;
    CGFloat sendButtonHeight;
}

OCS_CLASS_DYNAMIC_FLAG
//#if ENABLE_OCS_PLUGIN_REPLACE_METHODS && (!defined ODOCS_SWITCH_A)
//OCS_PLUGIN_METHODS_START

- (void)dealloc {
    
    if (_scrollView) {
        _scrollView.delegate = nil;
        [_scrollView release];
        _scrollView = nil;
    }
    
    if (_pageCtl) {
        [_pageCtl release];
        _pageCtl = nil;
    }
    
    if (_sendButton) {
        [_sendButton release];
        _sendButton = nil;
    }
    
    [super dealloc];
}

- (ODFaceboardViewController* )init {
    if (self = [super init]) {
        [self initValues];
    }
    return self;
}

- (void)initValues {
    lineSpacing = 25;
    cellWidth = 30;
    lineCell = 7;
    pageCell = 20;
    pageLine = 3;
    lrMargin = 20;
    tbMargin = 10;
    count = [[ODFaces shareInstance] count];
    rmBtnWidth = 30;
    rmBtnHeight = 28;
    boxHeight = SCREEN_HEIGHT;
    fbWidth = SCREEN_WIDTH;
    sendButtonHeight = 36;
    fbHeight = (pageLine * cellWidth) + ((pageLine - 1) * lineSpacing) + (tbMargin * 4) + sendButtonHeight + HOME_INDICATOR_HEIHT;
}

- (void)loadFaces
{
    int cellSpacing = (fbWidth - lineCell * cellWidth - lrMargin * 2) / (lineCell - 1);
    int scrollViewHeight = pageLine * cellWidth + (pageLine - 1) * lineSpacing + tbMargin * 2;
    int pageCount = count / pageCell;
    if (pageCount * pageCell < count) {
        pageCount++;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fbWidth, scrollViewHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(pageCount * fbWidth, scrollViewHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _pageCtl.numberOfPages = pageCount;
    _pageCtl.currentPage = 0;
    _pageCtl.center = CGPointMake(fbWidth / 2.0, scrollViewHeight + tbMargin);
    
    for (int i = 0; i < count; i++) {
        
        int left;
        int top;
        left = (i / pageCell * fbWidth) + lrMargin + ((i % pageCell % lineCell) * (cellWidth + cellSpacing));
        top = tbMargin + ((i % pageCell / lineCell) * (lineSpacing + cellWidth));
        
        UIImageView *faceImgView;
        UITapGestureRecognizer *tapGest;
        
        faceImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(left, top, cellWidth, cellWidth)] autorelease];
        faceImgView.tag = i;
        faceImgView.userInteractionEnabled = YES;
        faceImgView.image = [[ODFaces shareInstance] img_by_index:i];
        
        tapGest = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFace:)] autorelease];
        tapGest.numberOfTapsRequired = 1;
        tapGest.numberOfTouchesRequired = 1;
        tapGest.delegate = self;
        
        [faceImgView addGestureRecognizer:tapGest];
        [_scrollView addSubview:faceImgView];
        
        if (i % pageCell == pageCell - 1 || i == count - 1) {
            left += cellWidth + cellSpacing;
            top++;
            UIButton *rmBtn = [[[UIButton alloc] initWithFrame:CGRectMake(left, top, rmBtnWidth, rmBtnHeight)] autorelease];
            [rmBtn setImage:[UIImage loadBaseNetResImage:@"Room/del_btn_nor@2x.png"] forState:UIControlStateNormal];
            [rmBtn setImage:[UIImage loadBaseNetResImage:@"Room/del_btn_press@2x.png"] forState:UIControlStateHighlighted];
            [rmBtn addTarget:self action:@selector(onClickRmBtn) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:rmBtn];
        }
    }
}

- (void)onClickRmBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeFace)]) {
        [self.delegate removeFace];
    }
}

- (void)onClickFace:(UITapGestureRecognizer *)sender
{
    int index = (int)[sender view].tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(addFace:)]) {
        [self.delegate addFace:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.CZ_F_SizeW;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != _pageCtl.currentPage) {
        _pageCtl.currentPage = page;
        _scrollView.contentOffset = CGPointMake(fbWidth * _pageCtl.currentPage, _scrollView.contentOffset.y);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ODARGB2UICOLOR(0.96f*255, 255, 255, 255);
    self.view.frame = CGRectMake(0, boxHeight - fbHeight, fbWidth, fbHeight);
    
    _pageCtl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_pageCtl];
    _pageCtl.pageIndicatorTintColor = ODRGB2UICOLOR2(0xc8c8c8);
    _pageCtl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    UIView *bottomBar = [[UIView alloc] init];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = ODRGB2UICOLOR2(0xF8F8F8);
    bottomBar.pSize = CGSizeMake(self.view.pWidth, sendButtonHeight);
    [bottomBar pAlignParentBottomOffset:-HOME_INDICATOR_HEIHT];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomBar addSubview:_sendButton];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:kCZUIWhiteColor forState:UIControlStateNormal];
    _sendButton.backgroundColor = ODRGB2UICOLOR2(0xEE5B75);
    _sendButton.pSize = CGSizeMake(75, sendButtonHeight);
    [_sendButton pAlignParentRight];
    [_sendButton addTarget:self action:@selector(onSendBtnClick)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self loadFaces];
}

- (int)height {
    return fbHeight;
}

- (void)setSendButtonEnable:(BOOL)enable
{
    _sendButton.enabled = enable;
    _sendButton.backgroundColor = enable ? ODRGB2UICOLOR2(0xEE5B75) : ODRGB2UICOLOR2(0xE9EBEC);
}

- (void)onSendBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSendBtnClick)]) {
        [self.delegate onSendBtnClick];
    }
}

//OCS_PLUGIN_METHODS_END
//#endif

@end
#endif
