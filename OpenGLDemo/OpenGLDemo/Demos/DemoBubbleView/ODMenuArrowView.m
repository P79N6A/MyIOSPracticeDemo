#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "ODMenuArrowView.m"
#pragma clang diagnostic pop


#import "ODMenuArrowView.h"

@implementation ODMenuArrowView

- (void)dealloc
{
    self.color = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.color = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //设置背景颜色
    [[UIColor clearColor] set];
    
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    if (_isUp) {
        CGContextMoveToPoint(context, 0, self.bounds.size.height);//设置起点
        CGContextAddLineToPoint(context, self.bounds.size.width / 2, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
    } else {
        CGContextMoveToPoint(context, 0, 0);//设置起点
        CGContextAddLineToPoint(context, self.bounds.size.width, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width/2, self.bounds.size.height);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
    }
    [self.color setFill]; //设置填充色
    
    //[self.color setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}

@end
