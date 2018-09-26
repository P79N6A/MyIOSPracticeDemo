
#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "UITableViewDemoCtrlNew.h"
#import "ODChatCommonCellNew.h"
#import "ODChatCommonCellModel.h"
#import "ODMessage.h"
#import "GLiveCPUMonitor.h"

#define CHAT_LEFT_MARGIN 10
#define OD_MAX_DEPOSITION_MSG_COUNT 50 //最大沉淀消息数
#define OD_MAX_RESERVE_MSG_COUNT    20 //超出清除，保留的消息数

@interface UITableViewDemoNew ()<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate, GLiveCPUMonitorDelegate>{
    NSMutableArray<ODChatCommonCellModel*> *_cellModels;
    BOOL _2bottom;
    UILabel* _newMsgLabel;
    NSTimer* _timer;
    NSMutableArray* _sampleNickNameArray;
    UIFont *_font;
    GLiveCPUMonitor* _perfMonitor;
}

@property (nonatomic, retain) UITableView *tableView;
@end
    
@implementation UITableViewDemoNew

- (void)viewDidLoad {
    _cellModels = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                              style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.bounces = NO;
    CGRect rc = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
    
    _tableView.frame = rc;
    _tableView.hidden = NO;
    _2bottom = TRUE;
    
    _font = [UIFont systemFontOfSize:14.f];
    
    //int nMsgLabelHeight = 30 ;
    _newMsgLabel = [[UILabel alloc] init];
    [self.view addSubview:_newMsgLabel];
    _newMsgLabel.hidden = YES;
    _newMsgLabel.font = [UIFont systemFontOfSize:14];
    _newMsgLabel.backgroundColor = [UIColor whiteColor];
    _newMsgLabel.text = @"   有新的聊天消息,点击查看   ";
    _newMsgLabel.textColor = [UIColor grayColor];
    _newMsgLabel.userInteractionEnabled = YES;
    _newMsgLabel.alpha = 0.80;
    
    _newMsgLabel.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y + _tableView.frame.size.height - 30, 100, 30);
    
//    _sampleNickNameArray = [NSMutableArray arrayWithObjects:@"张三e维吾尔啥尔尔二恶DVD发",@"李四尔啥尔啥尔尔二恶D尔啥尔尔二恶D尔尔二恶D",@"王五",@"六麻子",@"七瘸子",@"赵婧文",@"赵竹林",@"赵威皓",@"赵冬梅",@"赵中锴",@"赵山川",@"赵吾光",@"赵璇尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D尔啥尔尔二恶D海",@"赵学海",@"赵午光",@"赵绚海",@"赵玉",@"赵吾行",@"赵晓珲",@"赵吾航",@"赵鳕海",@"赵腾",@"赵宵蕙",@"赵雾瑕",@"赵紫豪",@"赵涛",@"赵俊英",@"赵敏",@"赵轩海",@"赵家豪",@"赵鹃",@"赵文兵",@"赵海洲",@"赵玉凤",@"赵容",@"赵礼义",@"赵义",@"赵华良",@"赵宇",@"赵汝杰",@"赵萸艳",@"赵子峰",@"赵天宇",@"赵慧",@"赵艳",@"赵德霞",@"赵小瑞",@"赵玉芝",@"赵家宝",@"赵林",@"赵健民",@"赵立民",@"赵妍",@"赵大宇",@"赵彪", nil];
    
    
    _sampleNickNameArray = [NSMutableArray arrayWithObjects:@"张三e维吾尔啥尔尔二恶DVD发",@"李四尔啥尔啥尔尔二恶D尔啥尔尔二恶D尔尔二恶D",@"赵彪测试大厂名的热热二二二二二二而突然突然让人突然突然", nil];
    [_sampleNickNameArray retain];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
         action:@selector(onTouchNewMsgLabel:)];
    [_newMsgLabel addGestureRecognizer:tapGesture];
    
    [self.view bringSubviewToFront:_newMsgLabel];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(flushMessageInternal) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
//applechang
//NSString* jsonString = @"{\"x\":10,\"y\":422,\"w\":263,\"h\":43}";
//    NSString* jsonString = @"{\"field1\":\"value1\",\"field2\":\"value2\",\"field3\":\"value3\",\"field4\":\"value4\"}";
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSError *err = nil;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//    }
    
    _perfMonitor = [[GLiveCPUMonitor alloc]init];
    _perfMonitor.monitorDelegate = self;
    [_perfMonitor startMonitor];
}

-(void)clearCellModels:(NSRange)range
{
    if (_cellModels == nil) {
        return;
    }
    
    NSInteger end = range.location + range.length;
    for (NSInteger i = range.location; i< end; i++) {
        ODChatCommonCellModel* cellmodel = _cellModels[i];
        [cellmodel release];
    }
    
    [_cellModels removeObjectsInRange:range];
}

-(void)flushMessageInternal
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        ODPresentGiftMsg* msg = [[ODPresentGiftMsg alloc]init];
        msg.giftImgPath = (i % 2) ? [[NSBundle mainBundle] pathForResource:@"fafengche.png" ofType:nil]: [[NSBundle mainBundle] pathForResource:@"xiaohuangya.png" ofType:nil];
        msg.messageType = kODMessageType_GiftPresent;
        msg.fromNick = [self genRandomNickname:i];
        msg.toNick = [self genRandomNickname:(30-i)];
        
        [list addObject:msg];
    }
    [self addRichTextToChatTableView:list];
}

#pragma mark- GLiveCPUMonitorDelegate
- (void)didCaptureUsageLog:(NSArray *)cpuUsageLogs andBacktraceLog:(NSArray *)backtraceLogs
{
    for (int index = 0; index < cpuUsageLogs.count; index++) {
        NSLog(@"cupUsageLogs:%@", cpuUsageLogs[index]);
    }
    
    for (int i = 0; i< backtraceLogs.count; i++) {
        NSLog(@"backtraceLogs:%@", backtraceLogs[i]);
    }

}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reused = @"common";
    ODChatCommonCellNew *cell = [_tableView dequeueReusableCellWithIdentifier:reused];
    if (cell == nil) {
        cell = [[[ODChatCommonCellNew alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reused] autorelease];
    }
    else
    {
        [cell setNeedsDisplay];
    }
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = (NSUInteger) indexPath.row;
    if ([_cellModels count] > row) {
        ODChatCommonCellModel* model = _cellModels[row];
        return [model getCellHeight];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = (NSUInteger) indexPath.row;
    if (row < [_cellModels count]) {
        NSLog(@"applechang:tableview:willDisplayCell:%d", (int)row);
        if ([cell isKindOfClass:[ODChatCommonCellNew class]]) {
            ODChatCommonCellNew *commonCell = (ODChatCommonCellNew*)cell;
            ODChatCommonCellModel* model = [_cellModels objectAtIndex:row];
            if (model) {
                [commonCell setCommonCellModel:model];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat frameHeight = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomMargin = scrollView.contentSize.height - contentOffsetY;
    
    if (bottomMargin -20 <= frameHeight) {
        if (!_2bottom) {
            _2bottom = TRUE;
            [_tableView reloadData];
            [self scroll2Bottom];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y < 0) {
        _2bottom = FALSE;
    }
}


- (void)onTouchNewMsgLabel:(UITapGestureRecognizer *)sender
{
    _2bottom = TRUE;
    [_tableView reloadData];
    [self scroll2Bottom];
}

- (void)scroll2Bottom
{
    NSInteger count = [_tableView numberOfRowsInSection:0];
    if (count > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    _newMsgLabel.hidden = YES;
}



//- (AHRichItem *)newImageItem:(NSString *)imgPath {
//    ImageRichItem *item = [[ImageRichItem alloc] init];
//    item.image = [UIImage imageWithContentsOfFile:imgPath];
//    item.imageSize = CGSizeMake(item.image.size.width / 2,
//                                item.image.size.height / 2);
//    return item;
//}
//
//- (AHRichItem *)newImageItem:(NSString *)imgPath withSize:(CGSize)dstSize{
//    ImageRichItem *item = [[ImageRichItem alloc] init];
//    item.image = [self scaleToSize:[UIImage imageWithContentsOfFile:imgPath] size:dstSize];
//    item.imageSize = dstSize;
//    return item;
//}

-(NSString*)genRandomNickname:(int)seed
{
    srandom(seed*(unsigned int)time((time_t*)NULL));
    long value = random();
    long index = value % [_sampleNickNameArray count];
    
    return _sampleNickNameArray[index];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)addRichTextToChatTableView:(NSArray *)obj
{
    if (_cellModels.count > OD_MAX_DEPOSITION_MSG_COUNT) {
        //NSLog(@"applechangChatTest _autoHeightRichTexts.count:%d", (int)_autoHeightRichTexts.count);
        [self clearCellModels:NSMakeRange(0, obj.count)];
    }
    
    for (ODMessage* msg in obj) {
        ODChatCommonCellModel* model = [self ODChatMsg2TVCellModel:msg];
        [model setCellWidth:_tableView.frame.size.width - RIGHT_MARGIN_FIX];
        [_cellModels addObject:model];
    }
    
    NSLog(@"applechangChatTest _autoHeightRichTexts.count:%d", (int)_cellModels.count);
    if (_2bottom) {
        [_tableView reloadData];
        [self scroll2Bottom];
    }else{
        _newMsgLabel.hidden = NO;
    }
}

-(ODChatCommonCellModel*)ODChatMsg2TVCellModel:(ODMessage*)msg
{
    if (msg == nil) {
        return nil;
    }
    
    if (msg.messageType == kODMessageType_GiftPresent) {
        ODChatGiftCellModel* cellModel = [[ODChatGiftCellModel alloc]init];
        ODPresentGiftMsg* giftSendMsg = (ODPresentGiftMsg*)msg;
        
        ODChatTVCellNickNameItem* senderNick = [[ODChatTVCellNickNameItem alloc]init];
        senderNick.originText = msg.fromNick;
        UIColor* color1 = [UIColor colorWithRed:(255 / 255.0) green:(233 / 255.0) blue:(145 / 255.0) alpha:1.0];
        //        senderNick.textColor = ODRGB2UICOLOR(255, 233, 145);
        senderNick.textColor = color1;
        [color1 release];
        
        senderNick.textFont = _font;
        senderNick.uid = msg.fromUid;
        senderNick.nickname = msg.fromNick;
        [cellModel addItem:senderNick];
        
        ODChatTVCellTextSubRichitem* predicate  = [[ODChatTVCellTextSubRichitem alloc] init];
        predicate.originText = @" 送给 ";
        UIColor* color2 = [UIColor colorWithRed:(255 / 255.0) green:(233 / 255.0) blue:(145 / 255.0) alpha:0.7];
        //predicate.textColor = ODARGB2UICOLOR(255, 233, 145, 0.7f);
        predicate.textColor = color2;
        [color2 release];
        
        predicate.textFont = _font;
        [cellModel addItem:predicate];
        
        ODChatTVCellNickNameItem *RecNick = [[ODChatTVCellNickNameItem alloc] init];
        RecNick.originText = msg.toNick;
        UIColor* color3 = [UIColor colorWithRed:(255 / 255.0) green:(233 / 255.0) blue:(145 / 255.0) alpha:1.0];
        RecNick.textColor = color3;
        [color3 release];
        //RecNick.textColor = ODRGB2UICOLOR(255, 233, 145);
        RecNick.textFont = _font;
        RecNick.uid = msg.toUid;
        RecNick.nickname = msg.toNick;
        [cellModel addItem:RecNick];
        
        
        ODChatTVCellTextSubRichitem *count = [[ODChatTVCellTextSubRichitem alloc] init];
        
        count.originText = [NSString stringWithFormat:@" %lu个 ", giftSendMsg.giftset];
        UIColor* color4 = [UIColor colorWithRed:(255 / 255.0) green:(233 / 255.0) blue:(145 / 255.0) alpha:1.0];
        count.textColor = color4;
        [color4 release];
        //count.textColor = ODRGB2UICOLOR(255, 233, 145);
        count.textFont = _font;
        [cellModel addItem:count];
        
        
        ODChatTVCellImageSubRichitem* imageItem = [[ODChatTVCellImageSubRichitem alloc]init];
        imageItem.imageSize = CGSizeMake(20, 20);
        imageItem.image = [self scaleToSize:[UIImage imageWithContentsOfFile:giftSendMsg.giftImgPath] size:imageItem.imageSize];
        imageItem.asyncLoad = NO;
        
        //        ODUrlImageView* urlImageView = [[ODUrlImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) defaultImage:nil];
        //        urlImageView.backgroundColor = [UIColor clearColor];
        //        urlImageView.isResizeDefaultImage = NO;
        //        urlImageView.url = giftSendMsg.giftImgPath;
        //        [urlImageView loadUrl:giftSendMsg.giftImgPath];
        //
        //        imageItem.asyncImageView = urlImageView;
        //        imageItem.asyncLoad = YES;
        
        [cellModel addItem:imageItem];
        if (giftSendMsg.combo > 1) {
            ODChatTVCellTextSubRichitem *combo = [[ODChatTVCellTextSubRichitem alloc] init];
            combo.originText = [NSString stringWithFormat:@"  x %lu ", giftSendMsg.combo];
            UIColor* color4 = [UIColor colorWithRed:(255 / 255.0) green:(233 / 255.0) blue:(145 / 255.0) alpha:1.0];
            combo.textColor = color4;
            [color4 release];
            combo.textFont = [self loadBadaBoomFontWithSize:_font.pointSize];
            [cellModel addItem:combo];
        }
        
        return cellModel;
    }
//    }else{
//        ODChatCommonCellModel* cellModel = [[ODChatCommonCellModel alloc]init] autorelease;
//        NSString *fmt = [self addUserIndentityIcons:cellModel withMessage:msg] ? @" %@" : @"%@";
//        [cellModel addItem:[self nickname2RichItem:[NSString stringWithFormat:fmt, msg.fromNick]
//                                               uid:[msg.fromUid longLongValue]]];
//
//        ODChatTVCellTextSubRichitem* semiccolonItem = [[ODChatTVCellTextSubRichitem alloc]init];
//        semiccolonItem.originText = @": ";
//        UIColor* color5 = [UIColor colorWithRed:(255 / 255.0) green:(255 / 255.0) blue:(255 / 255.0) alpha:0.7f];
//        semiccolonItem.textColor = color5;
//        [color5 release];
//        semiccolonItem.textFont = _font;
//
//        [cellModel addItem:semiccolonItem];
//
//        for (NSObject *obj in msg.nativeRep) {
//            ODChatTVCellSubRichitem *subItem = [self ODMessageElem2RichItem:obj];
//            if (subItem) {
//                [cellModel addItem:subItem];
//            }
//        }
//        return cellModel;
//    }
    
    return nil;
}

@end
