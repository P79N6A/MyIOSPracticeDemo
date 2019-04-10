#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "ODPopoverPluginViewController.m"
#pragma clang diagnostic pop


#import "ODPopoverPluginViewController.h"
#import "ODCommonUIDef.h"

#define ANIM_KEY @"ANIM_KEY"

#define KEY_IN_ANIM @"inAnimation"
#define KEY_OUT_ANIM @"outAnimation"

#define KEY_BG_IN_ANIM @"bgInAnimation"
#define KEY_BG_OUT_ANIM @"bgOutAnimation"

@interface ODPopoverPluginViewController () <CAAnimationDelegate>

@property (nonatomic, assign) BOOL animating;

@end

@implementation ODPopoverPluginViewController


- (void)dealloc
{
    self.mainView = nil;
}

- (instancetype) init {
    if (self = [super init]) {
        _initHide = TRUE;
        //self.hideWhenClickOtherArea = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.initHide)
        [self.view setHidden:YES];
    
    //self.view.frame = self.rootView.frame;
    
    [self.view setBackgroundColor:ODARGB2UICOLOR2(0x00000000)];
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bgControl];
    [bgControl addTarget:self action:@selector(onBgTap) forControlEvents:UIControlEventTouchDown];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, self.view.frame.size.width-200, self.view.frame.size.height-400)];
    [self.view addSubview:self.mainView];
    self.mainView.userInteractionEnabled = YES;
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)show
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];//同上
    anim.fromValue = [NSNumber numberWithFloat:20];
    anim.toValue = [NSNumber numberWithFloat:0];
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];//同上
    anim1.fromValue = [NSNumber numberWithFloat:0];
    anim1.toValue = [NSNumber numberWithFloat:1];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anim, anim1, nil];
    groupAnimation.duration = 0.2f;
    
    return [self showWithAnim:groupAnimation];
}

- (BOOL)hide
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];//同上
    anim.fromValue = [NSNumber numberWithFloat:0];
    anim.toValue = [NSNumber numberWithFloat:20];
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];//同上
    anim1.fromValue = [NSNumber numberWithFloat:1];
    anim1.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anim, anim1, nil];
    groupAnimation.duration = 0.2f;
    //groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return [self hideWithAnim:groupAnimation];
}

- (BOOL)showWithAnim:(CAAnimation *)anim
{
//    if(!self.view.hidden || _animating) {
//        return NO;
//    }
    
    [self.view setHidden:NO];
    if(anim) {
        CABasicAnimation* bgAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        bgAnimation.fromValue = (id)[UIColor clearColor].CGColor;
        bgAnimation.toValue = (id)self.view.backgroundColor.CGColor;
        bgAnimation.duration = anim.duration;
        bgAnimation.fillMode = kCAFillModeBoth;
        bgAnimation.removedOnCompletion = YES;
        [bgAnimation setValue:KEY_BG_IN_ANIM forKey:ANIM_KEY];
        [self.view.layer addAnimation:bgAnimation forKey:KEY_BG_IN_ANIM];
        
        anim.fillMode = kCAFillModeBoth;
        anim.removedOnCompletion = YES;
        anim.delegate = self;
        [anim setValue:KEY_IN_ANIM forKey:ANIM_KEY];
        [self.mainView.layer addAnimation:anim forKey:KEY_IN_ANIM];
    }else{
        [self willViewAnimIn];
        [self didViewAnimIn];
    }
    return YES;
}

- (BOOL)hideWithAnim:(CAAnimation *)anim
{
    if(anim) {
        CABasicAnimation* bgAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        bgAnimation.fromValue = (id)self.view.backgroundColor.CGColor;
        bgAnimation.toValue = (id)[UIColor clearColor].CGColor;
        bgAnimation.duration = anim.duration;
        bgAnimation.fillMode = kCAFillModeForwards;
        bgAnimation.removedOnCompletion = NO;
        bgAnimation.delegate = self;
        [bgAnimation setValue:KEY_BG_OUT_ANIM forKey:ANIM_KEY];
        [self.view.layer addAnimation:bgAnimation forKey:KEY_BG_OUT_ANIM];
        
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        [anim setValue:KEY_OUT_ANIM forKey:ANIM_KEY];
        [self.mainView.layer addAnimation:anim forKey:KEY_OUT_ANIM];
    }else{
        [self willViewAnimOut];
        [self didViewAnimOut];
    }
    return YES;
}

- (void)onBgTap
{
    //if (self.hideWhenClickOtherArea) {
        [self hide];
    //}
}

- (void)willViewAnimIn
{
    [self.view setHidden:NO];
}

- (void)didViewAnimIn
{
    
}

- (void)willViewAnimOut
{
    
}

- (void)didViewAnimOut
{
    [self.view setHidden:YES];
    if(_hideWidthUnload) {
        //[self.roomContext unloadPlugin:self];  //卸载插件
    }
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    NSString *animKey = [anim valueForKey:ANIM_KEY];
    if ([animKey isEqualToString:KEY_IN_ANIM]) {
        [self willViewAnimIn];
    }else if ([animKey isEqualToString:KEY_OUT_ANIM]) {
        [self willViewAnimOut];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *animKey = [anim valueForKey:ANIM_KEY];
    if ([animKey isEqualToString:KEY_IN_ANIM]) {
        [self didViewAnimIn];
        [self.mainView.layer removeAnimationForKey:animKey];
    }else if ([animKey isEqualToString:KEY_OUT_ANIM]) {
        [self didViewAnimOut];
        [self.mainView.layer removeAnimationForKey:animKey];
    }else if ([animKey isEqualToString:KEY_BG_OUT_ANIM]) {
        [self.view.layer removeAnimationForKey:animKey];
    }else if ([animKey isEqualToString:KEY_BG_IN_ANIM]) {
        [self.view.layer removeAnimationForKey:animKey];
    }
}

//OCS_PLUGIN_METHODS_END
//#endif

@end
