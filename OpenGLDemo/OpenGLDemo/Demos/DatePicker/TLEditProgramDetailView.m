//

#import "TLEditProgramDetailView.h"
#import "UIView+BTPosition.h"
#import "FalcoUtilCore.h"
#import "IFalcoGrowingTextView.h"
#import "CommonUIDefine.h"
#import "PLUtilUIScreen.h"

#define PROGRAM_NAME_MAX_LENGTH 30
#define PROGRAM_DES_MAX_LENGTH 150

static const NSInteger kTimerDatePickerMaskTag = 0xEE;
static const NSInteger TIMEPICKERBOARD_HEIGHT = 256;

@interface TLEditProgramDetailView()<IFalcoGrowingTextViewDelegate>

//@property (nonatomic, strong) TLAddLiveCoverView * pickCoverView;
@property (nonatomic, strong) id<IFalcoGrowingTextView> liveNameTV;
@property (nonatomic, strong) UIButton * editTimeLabel;
@property (nonatomic, strong) UIView* line2;

@property (nonatomic, strong) UIImageView * editTimeArrowIV;
@property (nonatomic, strong) id<IFalcoGrowingTextView> liveDescribeTV;

@property (nonatomic, strong) UIDatePicker * datePicker;


@end

@implementation TLEditProgramDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark-TLAddLiveCoverDelegate
- (void)onCoverChange:(NSString *)url
{
}

#pragma mark-TLAddLiveCoverDelegate
- (void)onAddCoverClick
{
    [self hideKeyBoard];
}

- (void)displayDatePicker
{
    if (_datePicker && _datePicker.hidden == NO) {
        return;
    }
    
    UIControl *datePickerMaskView = [[UIControl alloc]initWithFrame:self.bounds];
    datePickerMaskView.backgroundColor = [UIColor blackColor];
    datePickerMaskView.alpha = 0.4;
    datePickerMaskView.tag = kTimerDatePickerMaskTag;
    [datePickerMaskView addTarget:self action:@selector(dismissDatePickerMask) forControlEvents:UIControlEventTouchDown];
    [self addSubview:datePickerMaskView];
    
    if (_datePicker == nil) {
        CGRect  frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TIMEPICKERBOARD_HEIGHT);
        frame = [self convertRect:frame fromView:self.window];
        _datePicker = [[UIDatePicker alloc]initWithFrame:frame];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    [self addSubview:_datePicker];
    [_datePicker setDate:[NSDate new]];
}

- (void)dismissDatePickerMask
{
    [self hiddenDatePicker];
}

- (void)hiddenDatePicker
{
    if (_datePicker && _datePicker.hidden == YES) {
        return;
    }
    
    // 做降下的动画
    [UIView animateWithDuration:0.5 animations:^{
        CGRect  frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, TIMEPICKERBOARD_HEIGHT);
        CGRect convertFrame = [self convertRect:frame toView:self.window];
        self.datePicker.frame = convertFrame;
    } completion:^(BOOL finished) {
        self.datePicker.hidden = YES;
        [self.datePicker removeFromSuperview];
    }];
    
    UIView *mask = [self viewWithTag:kTimerDatePickerMaskTag];
    [mask removeFromSuperview];
}


- (void)onEditTimeClick
{
    [self hideKeyBoard];
    [self displayDatePicker];
}

- (void)hideKeyBoard
{
//    [_liveNameTV.getView resignAllFirstResponder];
//    [_liveDescribeTV.getView resignAllFirstResponder];
}

- (void)datePickerValueChanged:(UIDatePicker *)picker
{
}

#pragma mark -IFalcoGrowingTextViewDelegate
- (void)growingTextViewDidChange:(id)growingTextView
{
}

@end
