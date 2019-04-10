#import "UIBubbleViewDemoCtrl.h"
#import "ODPopBubbleViewController.h"
#import "ODPopMenuItem.h"
#import "ODPopMenuViewController.h"
#import "UIScreenEx.h"

@interface UIBubbleViewDemoCtrl ()
{
    UILabel* _newMsgLabel;
    NSInteger _count;
    NSTimer* _timer;
}

@end
    
@implementation UIBubbleViewDemoCtrl

- (void)viewDidLoad {

    _newMsgLabel = [[UILabel alloc] init];
    [self.view addSubview:_newMsgLabel];
    _newMsgLabel.hidden = NO;
    _newMsgLabel.font = [UIFont systemFontOfSize:14];
    _newMsgLabel.backgroundColor = [UIColor blackColor];
    _newMsgLabel.text = @"点击查看";
    _newMsgLabel.textColor = [UIColor grayColor];
    _newMsgLabel.userInteractionEnabled = YES;
    _newMsgLabel.alpha = 0.80;
    
    _newMsgLabel.frame = CGRectMake(SCREEN_WIDTH - 300, SCREEN_HEIGHT-300, 80, 30);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(onShowBubbleView:)];
    [_newMsgLabel addGestureRecognizer:tapGesture];
    _count = 0;
}

-(void)flushTipsInternal
{
    ODPopMenuViewController* _bubble = [[ODPopMenuViewController alloc] init];
    _bubble.view.frame = self.view.frame;
    [self.view addSubview:_bubble.view];
    _count ++;
    ODPopTipViewItem* item = [[ODPopTipViewItem alloc]init];
    item.tipsDelegate = nil;
    item.isSingleLineTips = YES;
    item.point = CGPointMake(_newMsgLabel.frame.origin.x + _newMsgLabel.frame.size.width/2, _newMsgLabel.frame.origin.y);
    
    item.isUp = NO;
    item.hideAfterSec = 10;
    
    item.menuData =@[[ODPopMenuItem itemWithId:1 icon:nil name:[NSString stringWithFormat:@"第%ld位观众申请连麦,我试试", (long)_count]]];
    [_bubble tipsSchedule:item];
}

- (void)onShowBubbleView:(UITapGestureRecognizer *)sender
{
    [self flushTipsInternal];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(flushTipsInternal) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

@end
