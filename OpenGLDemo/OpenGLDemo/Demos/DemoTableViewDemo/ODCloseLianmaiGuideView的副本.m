#import "ODCloseLianmaiGuideView.h"
#import "ODMessage.h"

typedef NS_ENUM(NSInteger, CloseLianmaiViewMode){
    CloseLianmaiViewMode_None   =0,
    CloseLianmaiViewMode_Guide  = 1,
    CloseLianmaiViewMode_Button = 2,
};

@implementation ODCloseLianmaiGuideView
{
    UIImageView*            _guideCloseImageView;
    UILabel*                _tipsTextLabel;
    UIButton*               _closeLianmaiBtn;
    CloseLianmaiViewMode    _viewMode;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _viewMode = CloseLianmaiViewMode_None;
        self.backgroundColor = ODARGB2UICOLOR(0, 0, 0, 0);
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action: @selector(onClickViewRegion:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

-(void)onClickViewRegion:(UITapGestureRecognizer*)gesture
{
    [self hideSelf];
}

-(void)dealloc
{
    if (_guideCloseImageView) {
        //[_guideCloseImageView release];
    }
    
    if (_closeLianmaiBtn) {
        //[_closeLianmaiBtn release];
    }
    
    //[super dealloc];
}

- (UILabel*)createLabel:(CGRect)frame fontSize:(CGFloat)fontSize normalColor:(UIColor*)skinNormalColor highlightColor:(UIColor*)skinHighlightColor
{
    UILabel* label = nil;
    label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setTextColor:skinNormalColor];
    [label setHighlightedTextColor:skinHighlightColor];
    return label;
}

- (void)showGuide
{
    _viewMode = CloseLianmaiViewMode_Guide;
    _guideCloseImageView = [[UIImageView alloc]init];
    [_guideCloseImageView setImage:[UIImage imageNamed:@"closeLianmaiGuide"]];
    [self addSubview:_guideCloseImageView];
    _guideCloseImageView.hidden = NO;
    
    _tipsTextLabel = [self createLabel:CGRectZero fontSize:14 normalColor:[UIColor whiteColor] highlightColor:[UIColor whiteColor]];
    _tipsTextLabel.text = @"长按可结束连麦";
    [_tipsTextLabel sizeToFit];
    [self addSubview:_tipsTextLabel];
    _tipsTextLabel.hidden = NO;

    __weak id weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak_self hideSelf];
    });
}

- (void)showCloseButton
{
    _viewMode = CloseLianmaiViewMode_Button;

    _closeLianmaiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _closeLianmaiBtn.adjustsImageWhenHighlighted = YES;
    _closeLianmaiBtn.backgroundColor = ODRGB2UICOLOR(255,79,116);
    [_closeLianmaiBtn setTitle:@"结束连麦" forState:UIControlStateNormal];
    [_closeLianmaiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _closeLianmaiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_closeLianmaiBtn addTarget:self action:@selector(onCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [_closeLianmaiBtn.layer setMasksToBounds:YES];
    [_closeLianmaiBtn.layer setCornerRadius:15];
    _closeLianmaiBtn.hidden = NO;
    
    [self addSubview:_closeLianmaiBtn];
    
    __weak id weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak_self hideSelf];
    });
}

-(void)hideSelf
{
    if (CloseLianmaiViewMode_Button == _viewMode) {
        _closeLianmaiBtn.hidden = YES;
        [_closeLianmaiBtn removeFromSuperview];
        _closeLianmaiBtn = nil;
    }else if (CloseLianmaiViewMode_Guide == _viewMode) {
        _guideCloseImageView.hidden = YES;
        [_guideCloseImageView removeFromSuperview];
        _guideCloseImageView = nil;
        
        _tipsTextLabel.hidden = YES;
        [_tipsTextLabel removeFromSuperview];
        _tipsTextLabel = nil;
    }
    
    _viewMode = CloseLianmaiViewMode_None;
    self.hidden = YES;
}

- (void)onCloseButtonClick
{
    //结束连麦
}

- (void)layoutSubviews
{
    if (_viewMode == CloseLianmaiViewMode_Guide) {
        CGRect rcBackground = self.bounds;
        CGSize imagViwSize = _guideCloseImageView.image.size;
        CGPoint rcFrame1Pos;
        rcFrame1Pos.x = (rcBackground.size.width - imagViwSize.width)/2;
        rcFrame1Pos.y = (rcBackground.size.height - imagViwSize.height)/2;
        CGRect frame1 = CGRectMake(rcFrame1Pos.x, rcFrame1Pos.y, imagViwSize.width, imagViwSize.height);
        [_guideCloseImageView setFrame:frame1];
        
        CGSize szTips = _tipsTextLabel.frame.size;
        rcFrame1Pos.x = (rcBackground.size.width - szTips.width)/2; //居中
        rcFrame1Pos.y = rcFrame1Pos.y + frame1.size.height + 18;    //在图片bottom下18pt显示tips
        CGRect frame2 = CGRectMake(rcFrame1Pos.x , rcFrame1Pos.y, szTips.width, szTips.height);
        [_tipsTextLabel setFrame:frame2];
    }else if(_viewMode == CloseLianmaiViewMode_Button)
    {
        CGRect rcBackground = self.bounds;
        CGSize buttonSize = CGSizeMake(96, 30);
        CGPoint rcPostion;
        rcPostion.x = (rcBackground.size.width - buttonSize.width)/2;
        rcPostion.y = (rcBackground.size.height - buttonSize.height)/2;
        [_closeLianmaiBtn setFrame:CGRectMake(rcPostion.x, rcPostion.y, buttonSize.width, buttonSize.height)];
    }
}

@end
