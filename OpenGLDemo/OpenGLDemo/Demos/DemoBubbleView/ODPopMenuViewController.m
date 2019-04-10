#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "ODPopMenuViewController.m"
#pragma clang diagnostic pop


//
//  ODPopMenuViewController.m
//  ODApp
//
//  Created by britayin on 2017/6/1.
//  Copyright © 2017年 Tencent. All rights reserved.
//


#import "ODPopMenuViewController.h"
#import "UIView+BTVFL.h"
#import "ODPopMenuItem.h"
#import "ODMenuArrowView.h"
#import "UIView+BTPosition.h"
#import "NSString+TextSize.h"
#import "ODCommonUIDef.h"

@class ODMenuArrowView;

#define CELL_ID @"menu_cell"
#define ARROW_WIDTH 14
#define ARROW_HEIGHT 8

#define TEXT_FONT_SIZE 15
#define BORDER_MARGIN 4.5
#define LINE_HEIGHT 30

@implementation ODPopTipViewItem
-(instancetype)init
{
    if (self = [super init]) {
        self.isSingleLineTips = YES;
        self.hideAfterSec = 3;
        self.expire = NO;
        self.tipsDelegate = nil;
    }
    return self;
}

- (void)dealloc
{
    self.menuData = nil;
}

@end
@interface ODPopMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) ODMenuArrowView *arrowView;
@property (nonatomic, retain) CAGradientLayer* tableViewgradient;
@property (nonatomic, retain) NSMutableArray* tipsQueue;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) ODPopTipViewItem* curTipItem;
@end

@implementation ODPopMenuViewController
{
    CGPoint _showPoint;
    NSInteger _showCount;
    bool _isUp;
    BOOL _isIdle;
}


- (void)dealloc
{
    self.menuTableView.delegate = nil;
    
    self.menuTableView = nil;
    self.arrowView = nil;
    self.dataSource = nil;
    self.delegate = nil;
    self.tipsDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideWidthUnload = YES;
    _isIdle = YES;
    self.tipsQueue = [[NSMutableArray alloc]init];
    [self.mainView setBackgroundColor:[UIColor clearColor]];
    
    self.menuTableView = [[UITableView alloc] init];
    [self.mainView addSubview:self.menuTableView];
    [self.menuTableView setSeparatorColor:[UIColor clearColor]];
    self.menuTableView.showsVerticalScrollIndicator = NO;
    self.menuTableView.bounces = NO;
    self.menuTableView.alwaysBounceVertical = NO;
    self.menuTableView.alwaysBounceHorizontal = NO;
    //[self.menuTableView setBackgroundColor:ODARGB2UICOLOR2(0xF5FFFFFF)];
    self.menuTableView.layer.cornerRadius=15;
    self.menuTableView.layer.masksToBounds=YES;
    self.menuTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID];
    [self.menuTableView setBackgroundColor:[UIColor purpleColor]];
    
    _tableViewgradient = [CAGradientLayer layer];
    UIColor* start = ODRGB2UICOLOR(255, 79, 79);
    UIColor* end = ODRGB2UICOLOR(255, 79, 209);
    _tableViewgradient.colors =  @[(id)start.CGColor, (id)end.CGColor];
    _tableViewgradient.startPoint = CGPointMake(0, 0);
    _tableViewgradient.endPoint = CGPointMake(1, 0);
    
    self.arrowView = [[ODMenuArrowView alloc] initWithFrame:CGRectMake(0, 0, ARROW_WIDTH, ARROW_HEIGHT)];
    self.arrowView.color = ODRGB2UICOLOR(255, 79, 144);
    [self.mainView addSubview:self.arrowView];
    
    //布局
    //[self layout];
    self.view.hidden = YES;
}

- (void)tipsSchedule:(ODPopTipViewItem*)item
{
    if (item == nil) {
        return;
    }
    
    if (!_isIdle) {
        [_tipsQueue addObject:item];
    }else{
        _isIdle = NO;
        self.tipsDelegate = item.tipsDelegate;
        self.singleLineTips = item.isSingleLineTips;
        self.curTipItem = item;
        [self showIn:item.point menus:item.menuData isUp:item.isUp];
        [self hideAfterSeconds:item.hideAfterSec];
    }
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
    NSLog(@"colorOfPoint:R:%d,G:%d,B:%d", (int)pixel[0], (int)pixel[1], (int)pixel[2]);
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
    } else {
        self.menuTableView.frame = CGRectMake(0, 0, self.mainView.pWidth, self.mainView.pHeight-ARROW_HEIGHT);
    }
    
    self.menuTableView.backgroundView = [[UIView alloc]initWithFrame:self.menuTableView.bounds];
    
    _tableViewgradient.frame = self.menuTableView.backgroundView.bounds;
    [self.menuTableView.backgroundView.layer insertSublayer:_tableViewgradient atIndex:0];
    
    if (_isUp) {
        interpolationPixel = [self colorOfPoint:CGPointMake(self.arrowView.pCenterX, 10) withView:self.menuTableView.backgroundView];
    }else{
        interpolationPixel = [self colorOfPoint:CGPointMake(self.arrowView.pCenterX, self.menuTableView.frame.size.height - 10) withView:self.menuTableView.backgroundView];
    }
    self.arrowView.color = interpolationPixel;
    [self.arrowView setNeedsDisplay];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)showIn:(CGPoint)point menus:(NSArray *)menuData isUp:(bool)isUp
{
    self.dataSource = menuData;
    [self.menuTableView reloadData];
    
    _showPoint = point;
    _isUp = isUp;

    [self layout];
    
    [self show];
    
//    if (_singleLineTips) {
//        self.layerNo = ODRoomLayerNo_B;
//    }else{
//        self.layerNo = ODRoomLayerNo_Z;
//    }
}

- (BOOL)isShowing
{
    return !self.view.hidden;
}

- (BOOL)show
{
//    _showCount++;
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
    if (self.tipsDelegate) {
        [self.tipsDelegate tipsDisappear];
    }
    self.tipsDelegate = nil;
    
    [super didViewAnimOut];
    _isIdle = YES;
    
    if (_tipsQueue.count > 0) {
        ODPopTipViewItem* item = [_tipsQueue objectAtIndex:0];
        [_tipsQueue removeObjectAtIndex:0];
        [self tipsSchedule:item]; //调度
    }
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
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
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
    if ([self.delegate respondsToSelector:@selector(didMenuSelected:atIndex:)]) {
        ODPopMenuItem *data = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate didMenuSelected:data atIndex:indexPath.row];
        [self hide];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LINE_HEIGHT;
}

@end
