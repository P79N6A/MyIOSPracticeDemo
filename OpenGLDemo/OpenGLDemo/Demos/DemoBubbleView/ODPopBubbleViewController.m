#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "ODPopBubbleViewController.m"
#pragma clang diagnostic pop

#import "ODPopBubbleViewController.h"

#import "UIView+BTVFL.h"
#import "ODPopMenuItem.h"
#import "ODMenuArrowView.h"
#import "UIView+BTPosition.h"
#import "NSString+TextSize.h"
#import "ODCommonUIDef.h"


#define CELL_ID @"menu_cell"
#define ARROW_WIDTH 14
#define ARROW_HEIGHT 8

#define TEXT_FONT_SIZE 16
#define BORDER_MARGIN 4.5
#define LINE_HEIGHT 30
#define GLIVE_BUBBLE_CORNER_RADIUS 15

@interface ODPopBubbleViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *bgBubbleView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, strong) UILabel *textLbl;
@property (nonatomic, strong) CAGradientLayer* tableViewgradient;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) ODMenuArrowView *arrowView;
@property (nonatomic, strong) NSString* tipsContent;
@end


@implementation ODPopBubbleViewController
{
    CGPoint _showPoint;
    NSInteger _showCount;
    bool _isUp;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideWidthUnload = YES;
    [self.mainView setBackgroundColor:[UIColor clearColor]];
    
    self.menuTableView = [[UITableView alloc] init];
    [self.mainView addSubview:self.menuTableView];
    [self.menuTableView setSeparatorColor:[UIColor clearColor]];
    self.menuTableView.showsVerticalScrollIndicator = NO;
    self.menuTableView.bounces = NO;
    self.menuTableView.alwaysBounceVertical = NO;
    self.menuTableView.alwaysBounceHorizontal = NO;
    //[self.menuTableView setBackgroundColor:ODARGB2UICOLOR2(0xF5FFFFFF)];
    self.menuTableView.layer.cornerRadius=GLIVE_BUBBLE_CORNER_RADIUS;
    self.menuTableView.layer.masksToBounds=YES;
    self.menuTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID];
    
//    self.bgImageView = [[UIImageView alloc]init];
//    self.bgImageView.layer.cornerRadius = 15;
//    self.bgImageView.layer.masksToBounds=YES;
    
    UIColor* start = ODRGB2UICOLOR(255, 79, 79);
    UIColor* end = ODRGB2UICOLOR(255, 79, 209);
    self.tableViewgradient = [CAGradientLayer layer];
    self.tableViewgradient.colors =  @[(id)start.CGColor, (id)end.CGColor];
    
    self.tableViewgradient.startPoint = CGPointMake(0, 0);
    self.tableViewgradient.endPoint = CGPointMake(1, 0);

    //[self.bgImageView.layer insertSublayer:_gradient atIndex:0];
    
    //[self.mainView addSubview:self.bgImageView];
    
//    self.textLbl = [[UILabel alloc]init];
//    self.textLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
//    self.textLbl.textColor = [UIColor whiteColor];
//    self.textLbl.text = @"常平的测试消息";
//    [self.textLbl setBackgroundColor:[UIColor clearColor]];
//    [self.bgImageView addSubview:self.textLbl];

    self.arrowView = [[ODMenuArrowView alloc] initWithFrame:CGRectMake(0, 0, ARROW_WIDTH, ARROW_HEIGHT)];
    
    //self.arrowView.color = ODARGB2UICOLOR2(0xF5FF0000);
    [self.mainView addSubview:self.arrowView];
    
    
    //布局
    [self layout];
    self.view.hidden = YES;
}

- (UIColor *)colorOfPoint:(CGPoint)point withView:(UIView*)originView {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    [originView.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (void)layout
{
    CGFloat maxWidth = 0;
    for (ODPopMenuItem *item in self.dataSource) {
        CGFloat width = 16*2 + (_singleLineTips ? 0 : 10);
        if (item.icon) {
            width+=(20+16);
        }
        if (item.name) {
            CGFloat textWidth = [item.name sizeWithFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE]].width;
            width+=textWidth;
        }
        if (width > maxWidth) {
            maxWidth = width;
        }
    }
    
    if (!_singleLineTips) {
        self.mainView.pSize = CGSizeMake(maxWidth, self.dataSource.count*LINE_HEIGHT+18);
    }else{
        self.mainView.pSize = CGSizeMake(maxWidth, LINE_HEIGHT+ARROW_HEIGHT);
        self.menuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (_isUp) {
        self.mainView.pTop = _showPoint.y;
    } else {
        self.mainView.pBottom = _showPoint.y;
    }
    
    self.mainView.pCenterX = _showPoint.x;
    
    self.arrowView.isUp = _isUp;
    self.arrowView.pSize = CGSizeMake(ARROW_WIDTH, ARROW_HEIGHT);
    
    if (_isUp) {
        [self.arrowView pAlignParentTop];
    } else {
        [self.arrowView pAlignParentBottom];
    }
    
    
    if (self.mainView.pRight > self.view.pWidth - BORDER_MARGIN) {
        [self.mainView pAlignParentRightOffset:-BORDER_MARGIN];
    }else if (self.mainView.pLeft < BORDER_MARGIN) {
        [self.mainView pAlignParentLeftOffset:BORDER_MARGIN];
    }
    
    self.arrowView.pCenterX = _showPoint.x - self.mainView.pLeft;
    
    UIColor* interpolationPixel = [UIColor whiteColor];
    
    
    if (_isUp) {
        self.menuTableView.frame = CGRectMake(0, ARROW_HEIGHT, self.mainView.pWidth, self.mainView.pHeight-ARROW_HEIGHT);
        interpolationPixel = [self colorOfPoint:CGPointMake(self.arrowView.pCenterX, ARROW_HEIGHT) withView:self.mainView];
        
    } else {
        self.menuTableView.frame = CGRectMake(0, 0, self.mainView.pWidth, self.mainView.pHeight-ARROW_HEIGHT);
        interpolationPixel = [self colorOfPoint:CGPointMake(self.arrowView.pCenterX, self.menuTableView.frame.size.height) withView:self.mainView];
    }
    
    self.menuTableView.backgroundView = [[UIView alloc]initWithFrame:self.menuTableView.bounds];
    
    _tableViewgradient.frame = self.menuTableView.backgroundView.bounds;
    [self.menuTableView.backgroundView.layer insertSublayer:_tableViewgradient atIndex:0];
    self.arrowView.color = interpolationPixel;
    
    
    [self.arrowView setNeedsDisplay];
}

- (void)showIn:(CGPoint)point menus:(NSArray *)menuData isUp:(bool)isUp
{
    _showPoint = point;
    _isUp = isUp;
    _dataSource = menuData;
    
    [self layout];
    [self show];
}

- (BOOL)isShowing
{
    return !self.view.hidden;
}

- (BOOL)show
{
    _showCount++;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];//同上
    anim.fromValue = [NSNumber numberWithFloat:20];
    anim.toValue = [NSNumber numberWithFloat:0];
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];//同上
    anim1.fromValue = [NSNumber numberWithFloat:0];
    anim1.toValue = [NSNumber numberWithFloat:1];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anim, anim1, nil];
    groupAnimation.duration = 0.2f;
    //groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
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

- (void)didViewAnimOut
{
//    if (self.tipsDelegate) {
//        [self.tipsDelegate tipsDisappear];
//    }
//    self.tipsDelegate = nil;
    
    [super didViewAnimOut];
}

- (void)hideAfterSeconds:(NSTimeInterval)seconds
{
    [self performSelector:@selector(hideDelay:) withObject:@(_showCount) afterDelay:seconds];
}

- (void)hideDelay:(NSNumber *)showCount
{
    if (showCount.integerValue == _showCount) {
        [self hide];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ODPopMenuItem *data = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.imageView.image = data.icon;
    cell.textLabel.text = data.name;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:TEXT_FONT_SIZE];
    cell.textLabel.textColor = ODARGB2UICOLOR(255, 255, 255, 255);
    
    if (data.icon) {
        CGSize itemSize;
        if (data.icon.size.height <= data.icon.size.width) {
            itemSize = CGSizeMake(20, 20*data.icon.size.height/data.icon.size.width);
        }else{
            itemSize = CGSizeMake(20*data.icon.size.width/data.icon.size.height, 20);
        }
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [data.icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.delegate respondsToSelector:@selector(didMenuSelected:atIndex:)]) {
//        ODPopMenuItem *data = [self.dataSource objectAtIndex:indexPath.row];
//        [self.delegate didMenuSelected:data atIndex:indexPath.row];
//        [self hide];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LINE_HEIGHT;
}
@end
