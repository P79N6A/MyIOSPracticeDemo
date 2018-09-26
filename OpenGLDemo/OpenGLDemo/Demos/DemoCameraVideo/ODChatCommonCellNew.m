#import "ODChatCommonCellNew.h"

@implementation ODChatCommonCellNew {
    ODChatCommonCellModel* _cellModel;
}

-(instancetype)init
{
    if (self = [self init]) {
        _cellModel = nil;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)setCommonCellModel:(ODChatCommonCellModel*)cellModel
{
    _cellModel = cellModel;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTouch:)] autorelease];
    [self addGestureRecognizer:tapGesture];
}

- (void)onTouch:(id)sender {
    CGPoint point = [sender locationInView:self];
    if (_cellModel) {
        [_cellModel hitTest:point];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!_cellModel){
        return;
    }
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.5f), 1.0f);
    
    [_cellModel draw:self withRect:rect];
    
    CGContextRestoreGState(context);
}

@end

