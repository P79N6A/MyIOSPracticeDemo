
#import "ODChatCommonCell.h"

@implementation ODChatCommonCell {
    AutoHeightRichText * _richText;
    NSString* _simpleLabel;
    NSMutableArray *_imgViewPool;
}

- (void)dealloc {
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
    _imgViewPool = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(onTouch:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)onTouch:(id)sender {
    CGPoint point = [sender locationInView:self];
    point.y -= CELL_TOP_MARGIN;
    if (_richText) {
        [_richText hit:point];
    }
}

- (void)setItemRichText:(AutoHeightRichText *) richText
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor blackColor];
    _richText = richText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _richText.width = self.CZ_F_SizeW - RIGHT_MARGIN_FIX;
//    [_richText fit];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!_richText) {
        // clear
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.5f), 1.0f);

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *datenow = [NSDate date];
//    NSString *currentTimeString = [formatter stringFromDate:datenow];
//
//    NSLog(@"currentTimeString =  %@",currentTimeString);
//    UIColor* textColor = [UIColor blackColor];
//    [textColor set];
//
//    [currentTimeString drawInRect:rect withFont:[UIFont fontWithName:@"Courier" size:14]
//                     lineBreakMode: NSLineBreakByTruncatingTail
//                         alignment: NSTextAlignmentLeft
//      ];

    NSArray *drawItems = _richText.drawItems;
//    NSArray *subviews = self.subviews;
//    for (UIView *subview in subviews) {
//        if ([subview isKindOfClass:[ODUrlImageView class]]) {
//            [_imgViewPool addObject:subview];
//            [subview removeFromSuperview];
//        }
//    }
    for (DrawItem *item in drawItems) {
        if([item isKindOfClass:[TextDrawItem class]]) {
            TextDrawItem* td = (TextDrawItem *)item;
            [td.textColor set];
            CGRect tdRect = td.rect;
            //tdRect.origin.y += CELL_TOP_MARGIN;
            [td.text drawInRect:tdRect withFont:td.textFont];
        }else {
            ImageDrawItem* td = (ImageDrawItem *)item;
            CGRect rect = td.rect;
            rect.origin.y += CELL_TOP_MARGIN;
            if (td.image) {
                [td.image drawInRect:rect];
            }else{
                //NSAssert1(NO, <#desc#>, <#arg1#>)
                NSLog(@"不支持");
            }
//            } else if (td.url) {
//                // 这里要做一个对象池
//                ODUrlImageView *view;
//                if (_imgViewPool.count > 0) {
//                    view = [[(ODUrlImageView *)(_imgViewPool.lastObject) retain] autorelease];
//                    view.frame = rect;
//                    [_imgViewPool removeLastObject];
//                } else {
//                    view = [[[ODUrlImageView alloc] initWithFrame:rect
//                                                     defaultImage:nil] autorelease];
//                }
//
//                [self addSubview:view];
//                view.imageView.backgroundColor = [UIColor clearColor];
//                view.backgroundColor = [UIColor clearColor];
//                view.isResizeDefaultImage = NO;
//                td.urlLoaded = TRUE;
//                [view loadUrl:td.url];
//            }
        }
    }

    CGContextRestoreGState(context);
}

@end
