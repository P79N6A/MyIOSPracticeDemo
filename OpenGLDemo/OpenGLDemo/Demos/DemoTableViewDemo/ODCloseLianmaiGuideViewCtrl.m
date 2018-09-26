#import "ODCloseLianmaiGuideViewCtrl.h"
#import "ODLongPressCloseLianmaiGuideView.h"


@interface ODCloseLianmaiGuideViewCtrl (){
    ODLongPressCloseLianmaiGuideView* _longPressCloseLianmaiGuideView;
    ODLongPressCloseLianmaiButtonView* _longPressCloseLianmaiButtonView;
}
@end

@implementation ODCloseLianmaiGuideViewCtrl

- (void)viewDidLoad
{    
    UIImage* image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageview];
    imageview.frame = self.view.frame;
    imageview.contentMode = UIViewContentModeScaleToFill;
    
    _longPressCloseLianmaiGuideView = [[ODLongPressCloseLianmaiGuideView alloc]initWithFrame:self.view.frame];
    _longPressCloseLianmaiGuideView.hidden = FALSE;
    _longPressCloseLianmaiGuideView.userInteractionEnabled = YES;
    [self.view addSubview:_longPressCloseLianmaiGuideView];
    
    self.view.userInteractionEnabled  =YES;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1.5;
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_longPressCloseLianmaiGuideView) {
        [_longPressCloseLianmaiGuideView show];
    }
    [super viewDidAppear:animated];
}

-(void)longPress:(id)sender
{
    if (_longPressCloseLianmaiButtonView == nil)
    {
        _longPressCloseLianmaiButtonView = [[ODLongPressCloseLianmaiButtonView alloc]initWithFrame:self.view.frame];
        _longPressCloseLianmaiButtonView.userInteractionEnabled = YES;
        [self.view addSubview:_longPressCloseLianmaiButtonView];
    }
    
    [_longPressCloseLianmaiGuideView setFrame:self.view.bounds];
    [_longPressCloseLianmaiButtonView show];
}

@end
