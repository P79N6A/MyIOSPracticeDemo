
// retain属性 getter/setter/release
#define RETAIN_SETTER(prop) \
if (_##prop != prop) { \
[_##prop release]; \
_##prop = [prop retain]; \
} \

#define RETAIN_GETTER(prop) \
return [[_##prop retain] autorelease]\

#define RETAIN_RELEASE(prop) \
[_##prop release]; \
_##prop = nil; \

// copy属性 getter/setter/release
#define COPY_SETTER(prop) \
if (_##prop != prop) { \
[_##prop release]; \
_##prop = [prop copy]; \
} \

#define COPY_GETTER(prop) RETAIN_GETTER(prop)
#define COPY_RELEASE(prop) RETAIN_RELEASE(prop)

// assign属性 getter/setter/release
#define ASSIGN_SETTER(prop) _##prop = prop;
#define ASSIGN_GETTER(prop) return _##prop;
#define ASSIGN_RELEASE(prop)

// weak属性 getter/setter/release
#define WEAK_SETTER(prop) ASSIGN_SETTER(prop)
#define WEAK_GETTER(prop) ASSIGN_GETTER(prop)
#define WEAK_RELEASE(prop) ASSIGN_RELEASE(prop)

// strong属性 getter/setter/release （当retain了，不考虑string和block的copy）
#define STRONG_GETTER(prop) RETAIN_GETTER(prop)
#define STRONG_SETTER(prop) RETAIN_SETTER(prop)
#define STRONG_RELEASE(prop) RETAIN_RELEASE(prop)

//OCS不支持重写readonly/readwrite属性, 可以用这个这个宏替代 self.= 的赋值的语法
#define self_(prop, target) \
{   \
id t_t = target;    \
if (_##prop != t_t) { \
[_##prop release]; \
_##prop = nil;  \
_##prop = [t_t retain]; \
} \
}   \


#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODFreeChatViewController.h"
#import "BTVFL/UIView+BTVFL.h"
#import "ODMessage.h"


#define MAX_NICKNAME 12
#define MAX_TEXT 15
#define MAX_SECOND_MSG 60

@interface MyAnimationView : UIView
{
}
@end

@implementation MyAnimationView

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

@end


@interface ODChatMsgFreeItemView : UIView
@property (nonatomic, copy) NSString* nick;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) BOOL colon;
@property (nonatomic, assign) UInt64 uid;
@property (nonatomic, retain)UILabel* nickLabel;
@property (nonatomic, retain)UILabel* textLabel;
@property (nonatomic, retain)UILabel* colonLabel;
@end

@implementation ODChatMsgFreeItemView
{
    BOOL _colon;
}


-(UILabel*)getNickLabel
{
    return _nickLabel;
}

- (void)dealloc {
    [super dealloc];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initInternel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initInternel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self initInternel];
    }
    return self;
}

- (void)initInternel {
    self.backgroundColor = ODARGB2UICOLOR(0, 200, 0, 0);
    self.layer.masksToBounds = YES;
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    _nickLabel = [[UILabel alloc] init];
    _nickLabel.frame = CGRectMake(0, 0, 80, 40);
    _nickLabel.font = font;
    _nickLabel.textColor = ODRGB2UICOLOR(254, 209, 137);
    [_nickLabel setText:@"常平123"];
    _nickLabel.userInteractionEnabled = YES;
    _nickLabel.hidden = NO;
    [self addSubview:_nickLabel];
    [_nickLabel addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onTouch:)] autorelease]];
    
    
    _colonLabel = [[UILabel alloc] init];

    //[_colonLabel centerYTo:self];
    _colonLabel.frame = CGRectMake(80, 0, 10, 40);
    _colonLabel.text = @":";
    _colonLabel.font = font;
    _colonLabel.textColor = ODRGB2UICOLOR(254, 209, 137);
    _colonLabel.hidden = NO;
    [self addSubview:_colonLabel];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = font;
    [_textLabel setText:@"来测试一下"];
    _textLabel.textColor = ODRGB2UICOLOR(255, 255, 255);
    _textLabel.frame = CGRectMake(80, 0, 50, 40);
    _textLabel.hidden = NO;
    [self addSubview:_textLabel];
}

- (void)onNickChange {
    _nickLabel.text = _nick;
}


- (void)onTouch:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TestMessageBox"
                                                    message:@"ForTest"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end


@interface ODFreeChatViewController ()

@end

@implementation ODFreeChatViewController {
    ODChatMsgFreeItemView *_aniView1;
    UIView *_aniView2;
    UIView *_container;
    UIButton* _playBtn;
    NSMutableArray *_chatViews;
    NSMutableArray *_giftViews;
    NSMutableArray *_waitingMsgs;
    NSMutableDictionary *_queDict;
    NSMutableDictionary *_headDict;
    BOOL _isAning;
    BOOL _newAni;
    BOOL _flag;
    BOOL _cross;
    int  _lastItem1;
    int  _lastItem2;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    if (_aniView1) {
        [_aniView1.layer removeAllAnimations];
    }
    
//    if (_aniView2) {
//        [_aniView2.layer removeAllAnimations];
//    }
    
    RETAIN_RELEASE(aniView1);
    RETAIN_RELEASE(aniView2);
    RETAIN_RELEASE(container);
    RETAIN_RELEASE(chatViews);
    RETAIN_RELEASE(giftViews);
    RETAIN_RELEASE(waitingMsgs);
    RETAIN_RELEASE(queDict);
    RETAIN_RELEASE(headDict);
    
    [super dealloc];
}

- (void)load:(UIView *)container {
    if (_container) {
        [_container release];
        _container = nil;
    }
    _container = [container retain];
    [_container addSubview:self.view];
}

- (void)unload {
    if (_container) {
        if ([[_container subviews] containsObject:self.view]) {
            [self.view removeFromSuperview];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 恢复动画
    if (!_newAni) {
        [self ani];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lastItem1 = -1;
    _lastItem2 = -1;
    
    _flag = TRUE;
    _cross = FALSE;
    _isAning = FALSE;
    _newAni = TRUE;
    
    _headDict = [[NSMutableDictionary alloc] init];
    _queDict = [[NSMutableDictionary alloc] init];
    _chatViews = [[NSMutableArray alloc] init];
    _giftViews = [[NSMutableArray alloc] init];
    _waitingMsgs = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CGSize size = self.view.frame.size;
    _aniView1 = [[ODChatMsgFreeItemView alloc] init];
    _aniView1.backgroundColor = [UIColor blueColor];
    _aniView1.frame = CGRectMake(0, 500, size.width, 40);
    _aniView1.clipsToBounds = TRUE;
    _aniView1.userInteractionEnabled = YES;
    _aniView1.hidden = NO;
    [self.view addSubview:_aniView1];
    
    [self.view addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onTouchSelf:)] autorelease]];
    
    _playBtn = [[UIButton alloc] init];
    _playBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, 80, 30);
    [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    [_playBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(onPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.layer.cornerRadius = 10;
    _playBtn.layer.masksToBounds = YES;
    _playBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] CGColor];
    _playBtn.layer.borderWidth = 0.5;
    [self.view addSubview:_playBtn];
    
    [self.view bringSubviewToFront:_playBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [self addMsg:FALSE];
}

- (void)onPlayBtnClick
{
    [self ani];
}

- (void)addMsg:(BOOL)newCircle
{
    //_aniView1.frame = CGRectMake(0, 500, size.width, 40);
}

- (CGFloat)msgWidth:(NSString *)name
               text:(NSString *)text
              colon:(BOOL)colon {
    CGFloat width = _container.frame.size.height;
    if (name) {
        width += [self textWidth:name] + 10;
    }
    
    if (text) {
        width += [self textWidth:text] + 2;
    }
    
    return width + 5;
}

- (CGFloat)textWidth:(NSString *)text {
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.f]
                   constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    return size.width;
}

- (void)ani {
    [self doAni:10];
}

- (void)onAniSet {
    CGSize size = self.view.frame.size;
    _aniView1.frame = CGRectMake(0, 100, size.width, 40);
}

- (void)onAniEnd:(BOOL)finished {
    _isAning = FALSE;
}

- (void)onAniFinish
{
}

- (BOOL)isActive {
    return ([UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}


- (void)onTouchSelf:(id)sender{
    CGPoint touchPoint = [sender locationInView:self.view];
    CALayer* dstLayer = [_aniView1.layer.presentationLayer hitTest:touchPoint];
    CALayer* labelLayer = _aniView1.nickLabel.layer.presentationLayer;
    NSArray<CALayer *>* sublayers = labelLayer.sublayers;
    if (dstLayer == labelLayer) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TestMessageBox"
                                                        message:@"TouchClientArea"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        for (CALayer* item in sublayers) {
            if (dstLayer == item) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TestMessageBox"
                                                                message:@"TouchClientArea"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }

    }
    

    
//    CGRect rcLabel = labelLayer.frame;
//    if (dstLayer == labelLayer) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TestMessageBox"
//                                                        message:@"TouchClientArea"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
}


- (void)onApplicationDidBecomeActive:(NSNotification *)notification {
    [self ani];
}

- (NSString *)curTimeStr {
    return [NSString stringWithFormat:@"%.0lf",
            [[NSDate new] autorelease].timeIntervalSince1970];
}


- (void)doAni:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self onAniSet];
                     } completion:^(BOOL finished) {
                         [self onAniEnd:finished];
                     }];
}

@end

