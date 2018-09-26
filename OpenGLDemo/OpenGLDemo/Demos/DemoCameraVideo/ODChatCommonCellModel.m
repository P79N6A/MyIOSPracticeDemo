#import "ODChatCommonCellModel.h"

@implementation ODChatCellSubRenderObject
{
    
}
-(void)dealloc
{
    [super dealloc];
}

- (void)draw:(UIView*)cell withRect:(CGRect)rcCell
{
    
}

-(BOOL)hitTest:(CGPoint)pt
{
    return CGRectContainsPoint(self.rcDrawArea, pt) ? YES : NO;
}
@end

@implementation ODChatCellTextRenderObject
{
    
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}
-(void)dealloc
{
    self.text = nil;
    self.textColor = nil;
    self.textFont = nil;
    [super dealloc];
}

- (void)draw:(UIView*)cell withRect:(CGRect)rcCell
{
    [_textColor set];
    [_text drawInRect:self.rcDrawArea withFont:self.textFont];
}
@end

@implementation ODChatCellImageRenderObject
{
}

-(void)dealloc
{
    [_image release];
    _image = nil;
    
    [_asyncImageView release];
    _asyncImageView = nil;
    [super dealloc];
}

- (void)draw:(UIView*)cell withRect:(CGRect)rcCell
{
//    if (cell == nil) {
//        return;
//    }
    
    if (_asyncLoad && _asyncImageView) {
        _asyncImageView.frame = self.rcDrawArea;
        if (cell) {
            [cell addSubview: _asyncImageView];
        }

    }else if(_image)
    {
        CGRect rcTemp = self.rcDrawArea;
        [_image drawInRect:rcTemp];
    }
}
@end


//每个富文本里包含多个绘制项
@implementation ODChatTVCellSubRichitem
{
    
}

-(instancetype)init
{
    if (self = [super init]) {
        self.renderObjects = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(void)dealloc
{
    for (int i=0; i<self.renderObjects.count; i++) {
        [self.renderObjects[i] release];
    }
    
    [self.renderObjects removeAllObjects];
    [self.renderObjects release];
    self.renderObjects = nil;
    [super dealloc];
}

-(BOOL)hitTest:(CGPoint)pt
{
    return NO;
}

-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)width
              withLineHeight:(CGFloat)singleLineheight
{
    return CGRectMake(0, 0, 0, 0);
}

@end

@implementation ODChatTVCellTextSubRichitem
{
}

-(void)dealloc
{
    _originText = nil;
    _textFont = nil;
    _textColor = nil;
    [super dealloc];
}

-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)totalLineWidth
              withLineHeight:(CGFloat)singleLineheight
{
    if (_originText == nil) {
        return rcPreObject;
    }
    
    if (singleLineheight == 0) {
        return CGRectMake(0, 0, 0, 0);
    }

    NSRange fullRange = NSMakeRange(0, [_originText length]);
    __block int line = rcPreObject.origin.y / singleLineheight;
    __block CGRect rcPreObjectTemp = rcPreObject;
    [_originText enumerateSubstringsInRange:fullRange
                            options:NSStringEnumerationByComposedCharacterSequences
                         usingBlock:^(NSString * _Nullable substring,NSRange substringRange,
                                      NSRange enclosingRange,BOOL * _Nonnull stop) {
                             CGFloat offsetX = rcPreObjectTemp.origin.x + rcPreObjectTemp.size.width;
                             if ([substring isEqualToString:@"\n"]) {
                                 line++;
                                 rcPreObjectTemp.origin.x = 0;
                                 rcPreObjectTemp.origin.y = line*singleLineheight;
                                 rcPreObjectTemp.size.height = singleLineheight;
                                 rcPreObjectTemp.size.width = 0;
                             } else
                             {
                                 CGSize sizeSingleChar = [substring boundingRectWithSize:CGSizeMake(320,40)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                              attributes:@{NSFontAttributeName:_textFont}
                                                                                 context:nil].size;
                                 if (offsetX + sizeSingleChar.width > totalLineWidth) {
                                     line++;
                                     rcPreObjectTemp.origin.x = 0;
                                     rcPreObjectTemp.origin.y = line*singleLineheight;
                                     rcPreObjectTemp.size.height = singleLineheight;
                                     rcPreObjectTemp.size.width = 0;
                                 }
                                 offsetX = rcPreObjectTemp.origin.x + rcPreObjectTemp.size.width;
                                 
                                 ODChatCellTextRenderObject* renderObject = [[ODChatCellTextRenderObject alloc]init];
                                 renderObject.rcDrawArea = CGRectMake(offsetX, rcPreObjectTemp.origin.y, sizeSingleChar.width, sizeSingleChar.height);
                                 renderObject.textFont = _textFont;
                                 renderObject.text = substring;
                                 renderObject.textColor = _textColor;
                                 [self.renderObjects addObject:renderObject];
                                 rcPreObjectTemp = renderObject.rcDrawArea;
                             }
                         }];
    return rcPreObjectTemp;
}
@end


@implementation ODChatTVCellNickNameItem
-(instancetype)init
{
    if (self = [super init]) {
    }
    
    return self;
}

-(void)dealloc
{
    _uid = nil;
    _nickname = nil;
    _itemClickBlock = nil;
    [super dealloc];
}

- (BOOL)hitTest:(CGPoint)pt
{
    for (NSInteger i = 0; i< [self.renderObjects count] ; i++)
    {
        ODChatCellSubRenderObject* renderObject = (ODChatCellSubRenderObject*)self.renderObjects[i];
        if ([renderObject hitTest:pt]) {
            NSLog(@"hitTest nick"); //命中
            if (_itemClickBlock) {
                _itemClickBlock();
            }
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation ODChatTVCellImageSubRichitem
{
}

-(void)dealloc
{
    self.image = nil;
    self.asyncImageView = nil;
    [super dealloc];
}

//+ (ODChatTVCellImageSubRichitem *)newImageItem:(NSString *)imgPath withSize:(CGSize)dstSize{
//    ODChatTVCellImageSubRichitem *item = [[ODChatTVCellImageSubRichitem alloc] init];
//    item.image = [ODChatTVCellImageSubRichitem scaleToSize:[UIImage imageWithContentsOfFile:imgPath] size:dstSize];
//    item.imageSize = dstSize;
//    return item;
//}

//+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}

//返回最后一个renderobject 的rect
-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)totalLineWidth
              withLineHeight:(CGFloat)singleLineheight
{
    int line = rcPreObject.origin.y / singleLineheight;
    CGRect rcPreObjectTemp = rcPreObject;
    CGFloat offsetX = rcPreObjectTemp.origin.x + rcPreObjectTemp.size.width;
    if (offsetX + _imageSize.width > totalLineWidth) {
        line++;
        rcPreObjectTemp.origin.x = 0;
        rcPreObjectTemp.origin.y = line*singleLineheight;
        rcPreObjectTemp.size.height = singleLineheight;
        rcPreObjectTemp.size.width = 0;
    }
    
    offsetX = rcPreObjectTemp.origin.x + rcPreObjectTemp.size.width;
    ODChatCellImageRenderObject* renderObject = [[ODChatCellImageRenderObject alloc]init];
    renderObject.rcDrawArea = CGRectMake(offsetX, rcPreObjectTemp.origin.y, _imageSize.width, _imageSize.height);
    renderObject.asyncLoad = _asyncLoad;
    if (_asyncLoad) {
        renderObject.asyncImageView = _asyncImageView;
    }else{
        renderObject.image = _image;
    }
    
    rcPreObjectTemp = renderObject.rcDrawArea;
    [self.renderObjects addObject:renderObject];
    return rcPreObjectTemp;
}

@end



@implementation ODChatCommonCellModel
{
    CGFloat _width;
    CGFloat _height;
    CGFloat _singleLineH;
    BOOL    _needRelayout;
}

- (instancetype)init {
    if (self = [super init]) {
        _richItems = [[NSMutableArray alloc]init];
        _width = 0;
        _height = 0;
        _singleLineH = kODChatTVCellDefHeight; //缺省单行高（一个cell里面可能包含多行）
        _finalImage = nil;
    }
    return self;
}
-(void)dealloc
{
    NSLog(@"applechangChatTest ODChatCommonCellModel dealloc");
    for (int i=0; i<_richItems.count; i++) {
        [_richItems[i]release];
    }
    
    [_richItems removeAllObjects];
    [_richItems release];
    _richItems = nil;
    [_finalImage release];
    _finalImage = nil;
    [super dealloc];
}

-(void)layoutSubItemsInternal
{
    if (_width == 0) {
        return;
    }
    
    CGRect rcTemp = CGRectMake(0, 0, 0, 0);
    for (NSInteger index =0; index < [_richItems count]; index++) {
        ODChatTVCellSubRichitem* richItem = (ODChatTVCellSubRichitem*)_richItems[index];
        [richItem.renderObjects removeAllObjects];    //首先清空每个item包含的renderobjects
        
        rcTemp = [richItem createRenderObjects:rcTemp
                                 withLineWidth:_width
                                withLineHeight:_singleLineH]; //创建渲染对象
    }
    
    _height = rcTemp.origin.y + _singleLineH;
}

- (void)setCellWidth:(CGFloat)width
{
    if (width == _width) {
        return;
    }
    _width = width;
    [self layoutSubItemsInternal];
}

- (CGFloat)getCellWidth
{
    return _width;
}

- (CGFloat)getCellHeight
{
    return _height;
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    _singleLineH = lineHeight;
}

- (void)preprocessCell
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([self getCellWidth]   , [self getCellHeight]), NO, [UIScreen mainScreen].scale);
    for (NSInteger index =0; index < [_richItems count]; index++) {
        ODChatTVCellSubRichitem* richItem = (ODChatTVCellSubRichitem*)_richItems[index];
        if (richItem.renderObjects == nil) {
            continue;
        }
        
        for (NSInteger i = 0; i< [richItem.renderObjects count] ; i++) {
            ODChatCellSubRenderObject* renderObject = (ODChatCellSubRenderObject*)richItem.renderObjects[i];
            [renderObject draw:nil withRect:CGRectZero];
        }
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [image retain];
    _finalImage = image;
    
}

- (void)draw:(UIView*)cell withRect:(CGRect)rcCell
{
    __unused CGRect rcFrame = cell.frame;
    
    [_finalImage drawInRect:rcCell];
//    for (NSInteger index =0; index < [_richItems count]; index++) {
//        ODChatTVCellSubRichitem* richItem = (ODChatTVCellSubRichitem*)_richItems[index];
//        if (richItem.renderObjects == nil) {
//            continue;
//        }
//
//        for (NSInteger i = 0; i< [richItem.renderObjects count] ; i++) {
//            ODChatCellSubRenderObject* renderObject = (ODChatCellSubRenderObject*)richItem.renderObjects[i];
//            [renderObject draw:cell withRect:rcCell];
//        }
//    }
}

- (void)addItem:(ODChatTVCellSubRichitem *)item
{
    if (item == nil) {
        return;
    }
    [_richItems addObject:item];
    
}

- (void)addItemArray:(NSArray *)items
{
    if (items == nil) {
        return;
    }
    
    [_richItems addObjectsFromArray:items];
}

- (BOOL)hitTest:(CGPoint)pt
{
    for (NSInteger index =0; index < [_richItems count]; index++) {
        ODChatTVCellSubRichitem* richItem = (ODChatTVCellSubRichitem*)_richItems[index];
        if([richItem hitTest:pt])
        {
            return YES;
        }
    }
    
    return NO;
}
@end

@implementation ODChatGiftCellModel
@end

@implementation ODChatHintCellModel


-(instancetype)initWithWidth:(CGFloat)width
{
    if (self = [super init]) {
        
//        ODChatTVCellTextSubRichitem* tips1 = [[ODChatTVCellTextSubRichitem alloc] init];
//        tips1.originText = NSLocalizedString(@"视频房间全新升级！为保护信息安全，视频房间文字聊天不再与QQ群同步。\n", @"");
//        tips1.textColor = [UIColor colorWithRed: ODTlibGetRValue(0xffff6b89)/255.0 green:ODTlibGetGValue(0xffff6b89)/255.0 blue:ODTlibGetBValue(0xffff6b89)/255.0 alpha:(ODTlibGetAValue(0xffff6b89))/255.0];
//
//        tips1.textFont = [UIFont systemFontOfSize:14.f];
//        [self addItem:tips1];
//
//        ODChatTVCellTextSubRichitem *tips2 = [[ODChatTVCellTextSubRichitem alloc] init];
//        tips2.originText = NSLocalizedString(@"请使用文明用语，禁止传播低俗、违法内容。", @"");
//        tips2.textColor = [UIColor colorWithRed: 1.0f green:1.0f blue:1.0f alpha:1.0];
//        tips2.textFont =[UIFont systemFontOfSize:14.f];
//        [self addItem:tips2];
//
//        [self setLineHeight:20];
//        [self setCellWidth:width];
    }
    
    return self;
}
-(void)dealloc
{
    [super dealloc];
}
@end
