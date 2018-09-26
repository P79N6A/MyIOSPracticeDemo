#import "ODLongPressCloseLianmaiGuideView.h"
#import "ODMessage.h"

#define OD_MAX_DELAY_HIDE_SHADOWLAYER_SEC 3

@implementation ODShadowLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ODARGB2UICOLOR(0.5f*255, 0, 0, 0);
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action: @selector(onClickViewRegion:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

-(void)onClickViewRegion:(UITapGestureRecognizer*)gesture
{
    self.hidden = YES;
}

-(void)show
{
    self.hidden = NO;
}
@end

@implementation ODLongPressCloseLianmaiGuideView
{
    UIImageView*            _guideCloseImageView;
    UILabel*                _tipsTextLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _guideCloseImageView = [[UIImageView alloc]init];
        [_guideCloseImageView setImage:[UIImage imageNamed:@"closeLianmaiGuide"]];
        [self addSubview:_guideCloseImageView];
        
        _tipsTextLabel = [self createLabel:CGRectZero
                                  fontSize:14
                               normalColor:[UIColor whiteColor]
                            highlightColor:[UIColor whiteColor]];
        _tipsTextLabel.text = @"长按可结束连麦";
        [_tipsTextLabel sizeToFit];
        [self addSubview:_tipsTextLabel];
    }
    
    return self;
}

-(void)dealloc
{
    if (_guideCloseImageView) {
        [_guideCloseImageView release];
    }

    if (_tipsTextLabel) {
        [_tipsTextLabel release];
    }

    [super dealloc];
}

- (UILabel*)createLabel:(CGRect)frame
               fontSize:(CGFloat)fontSize
            normalColor:(UIColor*)skinNormalColor
         highlightColor:(UIColor*)skinHighlightColor
{
    UILabel* label = nil;
    label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setTextColor:skinNormalColor];
    [label setHighlightedTextColor:skinHighlightColor];
    return label;
}

- (void)layoutSubviews
{
    CGRect rcBackground = self.bounds;
    if (rcBackground.size.width == 0 || rcBackground.size.height == 0) {
        return;
    }
    
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
}

-(void)show
{
    [super show];
//    [ODMiscUtil dispatch_after_mainQueue:self
//                                   onSet:@selector(onClickViewRegion:)
//                                duration:(int64_t)(OD_MAX_DELAY_HIDE_SHADOWLAYER_SEC * NSEC_PER_SEC)
//                                  exInfo:@{}];
}
@end


@implementation ODLongPressCloseLianmaiButtonView
{
    UIButton*               _closeLianmaiBtn;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _closeLianmaiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_closeLianmaiBtn retain];
        
        _closeLianmaiBtn.adjustsImageWhenHighlighted = YES;
        _closeLianmaiBtn.backgroundColor = ODRGB2UICOLOR(255,79,116);
        [_closeLianmaiBtn setTitle:@"结束连麦" forState:UIControlStateNormal];
        [_closeLianmaiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeLianmaiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeLianmaiBtn addTarget:self action:@selector(onCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeLianmaiBtn.layer setMasksToBounds:YES];
        [_closeLianmaiBtn.layer setCornerRadius:15];
        [self addSubview:_closeLianmaiBtn];
    }
    return self;
}

-(void)dealloc
{
    if (_closeLianmaiBtn) {
        [_closeLianmaiBtn release];
    }
    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect rcBackground = self.bounds;
    if (rcBackground.size.width == 0 || rcBackground.size.height == 0) {
        return;
    }
    
    CGSize buttonSize = CGSizeMake(96, 30);
    CGPoint rcPostion;
    rcPostion.x = (rcBackground.size.width - buttonSize.width)/2;
    rcPostion.y = (rcBackground.size.height - buttonSize.height)/2;
    [_closeLianmaiBtn setFrame:CGRectMake(rcPostion.x, rcPostion.y, buttonSize.width, buttonSize.height)];
}

-(void)show
{
    [super show];
    
//    [ODMiscUtil dispatch_after_mainQueue:self
//                                   onSet:@selector(onClickViewRegion:)
//                                duration:(int64_t)(OD_MAX_DELAY_HIDE_SHADOWLAYER_SEC * NSEC_PER_SEC)
//                                  exInfo:@{}];
}

- (void)onCloseButtonClick
{
    //结束连麦
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickCloseLianmaiButton)]) {
        [self.delegate onClickCloseLianmaiButton];
    }
}

@end
