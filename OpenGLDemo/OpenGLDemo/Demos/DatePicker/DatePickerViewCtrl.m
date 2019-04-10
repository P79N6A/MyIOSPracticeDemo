#import "DatePickerViewCtrl.h"
#import "UIView+BTLayout.h"

@interface DatePickerViewCtrl ()
{
}
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UITextView * testTextView;

@end

@implementation DatePickerViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * timeLabel = [[UILabel alloc] init];
    [timeLabel setText:@"直播时间"];
    
    timeLabel.textColor = [UIColor colorWithRed:(119 / 255.0) green:(119 / 255.0) blue:(119 / 255.0) alpha:1.0];
    
    timeLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:timeLabel];
    [timeLabel sizeToFit];
    timeLabel.pTop = 100;
    timeLabel.pX = 0;
    
    self.datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    _datePicker.hidden = NO;
    _datePicker.pWidth = self.view.pWidth;
    _datePicker.pHeight = 216;
    _datePicker.pCenterX = self.view.center.x;
    _datePicker.pY = self.view.pHeight - _datePicker.pHeight;
    
    _testTextView = [[UITextView alloc] init];
    _testTextView.pX = 0;
    _testTextView.pTop = 200;
    _testTextView.pWidth = 200;
    _testTextView.pHeight = 200;
    _testTextView.scrollEnabled = NO;
    _testTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
    _testTextView.contentInset = UIEdgeInsetsZero;
    _testTextView.showsHorizontalScrollIndicator = NO;
    _testTextView.text = @"-";
    _testTextView.contentMode = UIViewContentModeRedraw;
    _testTextView.textColor = [UIColor blackColor];
    _testTextView.tintColor = [UIColor colorWithRed:(187 / 255.0) green:(187 / 255.0) blue:(187 / 255.0) alpha:1.0];
    [self.view addSubview:_testTextView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)datePickerValueChanged:(UIDatePicker *)picker
{
    // TODO
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    //设置时间格式
    formatter.dateFormat = @"yyyy.MM.dd HH:mm";
    NSString* dataStr = [formatter stringFromDate:self.datePicker.date];
    
}
@end
