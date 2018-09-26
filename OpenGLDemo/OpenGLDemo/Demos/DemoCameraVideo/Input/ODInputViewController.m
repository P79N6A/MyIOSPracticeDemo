#import "ODInputViewController.h"
#import "ODMessage.h"

#import "ODGrowingTextView.h"

#define KFacialSizeWidth  24.0    //表情的长宽
#define KFacialSizeHeight 24.0

@interface ODInputViewController () <ODGrowingTextViewDelegate, UIGestureRecognizerDelegate>
{
    UIView *_content;
    //UIButton *_faceBtn;
    
    ODGrowingTextView *_text;
    ODInputLogic *_logic;
    
    int _cellHeight;
    int _keyboardHeight;
    int _faceboardHeight;
}

@end

@implementation ODInputViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_content) {
        [_content release];
        _content = nil;
    }
    
    if (_text) {
        [_text release];
        _text = nil;
    }
    
    if (_logic) {
        [_logic release];
        _logic = nil;
    }
    
    if (_faceboard) {
        [_faceboard release];
        _faceboard = nil;
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    GLiveLogFinal("ODInputViewController viewDidLoad");
    
    [super viewDidLoad];
    
    self.view.frame = self.rootView.frame;
    self.view.backgroundColor = kCZUIClearColor;
    
    _logic = [[ODInputLogic alloc] init];
    
    [self initInternalUI];
    [self initNotification];
    [self initGesture];
    [self hideFloatingBoard];
    
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)initGesture {
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTouchBlank:)] autorelease];
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGestureContent = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(onTouchContent:)] autorelease];
    [_content addGestureRecognizer:tapGestureContent];
}

- (void)initInternalUI
{
//    _content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:_content];
    
    // faceBtn
    
    // text
    _text = [[ODGrowingTextView alloc] init];
    [_content addSubview:_text];
    _text.minNumberOfLines = 1;
    _text.maxNumberOfLines = 6;
    _text.font = [UIFont systemFontOfSize:16.f];
    _text.textColor = kCZUIBlackColor;
    _text.delegate = self;
    _text.placeholder = NSLocalizedString(@"说点什么", @"");
    _text.placeholderColor = ODRGB2UICOLOR(187, 187, 187);
    _text.backgroundColor = kCZUIClearColor;
    _text.returnKeyType = UIReturnKeySend;
    _text.enablesReturnKeyAutomatically = YES;
    _text.maxLength = 15;
}

- (void)testSend {
    NSDate *date = [NSDate date];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"HH-mm-ss"];
    NSString *dateStr = [forMatter stringFromDate:date];
    _text.text = dateStr;
    [self sendMsg];
}

- (void)updateInternalUI
{
//    // faceBtn
//    _faceBtn.frame = CGRectMake(12, (_cellHeight - 24) / 2.0, 24, 24);
    
    // text
//    if (self.room.stage.stageMode == ODStageMode_Free) {
//        _faceBtn.hidden = TRUE;
//        int textWidth = SCREEN_WIDTH - 13;
//        _text.frame = CGRectMake(8, 4, textWidth, _cellHeight - 9);
//    } else if (self.room.stage.stageMode == ODStageMode_Perform) {
//        _faceBtn.hidden = FALSE;
//        int textWidth = SCREEN_WIDTH - _faceBtn.pRight - 13;
//        _text.frame = CGRectMake(_faceBtn.pRight + 8, 4, textWidth, _cellHeight - 9);
//    }
    
//    int floatHeight = _faceboardHeight > _keyboardHeight ? _faceboardHeight : _keyboardHeight;
//    if (floatHeight > 0) {
//        _content.frame = CGRectMake(0, SCREEN_HEIGHT - _cellHeight - floatHeight, SCREEN_WIDTH, _cellHeight);
//        _content.backgroundColor = ODARGB2UICOLOR(0.96f*255, 255, 255, 255);
//        [self resetTextStyle];
//        self.view.hidden = FALSE;
//    } else {
//        _content.frame = CGRectMake(0, SCREEN_HEIGHT - _cellHeight, SCREEN_WIDTH, _cellHeight);
//        _content.backgroundColor = kCZUIClearColor;
//
//        if (_faceboard != nil) {
//            [_faceboard.view removeFromSuperview];
//        }
//        self.view.hidden = YES;
//    }
//
//    ODChatViewController *chatVc = [self.roomContext getPluginById:ODRoomPluginId_Chat];
//    if (chatVc && [chatVc respondsToSelector:@selector(setKeyBoardHeight:)]) {
//        [chatVc setKeyBoardHeight:floatHeight];
//    }
}
#pragma mark - Notification

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self doHideKeyboardAni:duration];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (![_text isFirstResponder]) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat keyBoardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self doShowKeyboardAni:duration
             keyboardHeight:keyBoardHeight];
}

- (void)onHideKeyboardAniSet {
    [self setKeyboardHeight:0];
    [self updateInternalUI];
}

- (void)onShowKeyboardAniSet:(CGFloat)height {
    [self setKeyboardHeight:height];
    [self updateInternalUI];
}

- (void)setKeyboardHeight:(int)height {
    _keyboardHeight = height;
}

- (void)onTouchBlank:(id)sender
{
    [self hideFloatingBoard];
}

- (void)onTouchContent:(id)sender
{
}

- (void)onSendBtnClick
{
    GLiveLogFinal("ODInputViewController onSendBtnClick");
    [self sendMsg];
}

- (void)resetTextStyle {
    NSRange wholeRange = NSMakeRange(0, _text.internalTextView.textStorage.length);
    
    [_text.internalTextView.textStorage removeAttribute:NSFontAttributeName
                                                  range:wholeRange];
    [_text.internalTextView.textStorage addAttribute:NSFontAttributeName
                                               value:[UIFont systemFontOfSize:16]
                                               range:wholeRange];
    [_text.internalTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                               value:kCZUIBlackColor
                                               range:wholeRange];
    [_text refreshHeight];
}


#pragma mark - ODRoomEvent

- (void)hideFloatingBoard
{
    GLiveLogFinal("ODInputViewController hideFloatingBoard");
    _faceboardHeight = 0;
    _keyboardHeight = 0;
    _cellHeight = 0;
    
    [_text resignFirstResponder];
    [self updateInternalUI];
}

#pragma mark - ODGrowingTextViewDelegate

- (void)growingTextView:(ODGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.CZ_F_SizeH - height);
    
    if (diff != 0) {
        _cellHeight -= diff;
        [self updateInternalUI];
    }
}

- (BOOL)growingTextViewShouldReturn:(ODGrowingTextView *)growingTextView
{
    [self sendMsg];
    return TRUE;
}

- (void)growingTextViewDidChange:(ODGrowingTextView *)growingTextView
{
    NSString *_msgText = [_text.internalTextView.textStorage getPlainString];
    NSString *trimedStr = [_msgText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_faceboard) {
        if (_msgText.length > 0 && trimedStr.length > 0) {
            [_faceboard setSendButtonEnable:YES];
        }else{
            [_faceboard setSendButtonEnable:NO];
        }
    }
}

- (void)bringTop
{
    [_text becomeFirstResponder];
}

- (void)showHint:(NSString *)content {
    [ODCommonTips showWarningToast:content];
}

- (BOOL)sendMsg
{
    NSString *_msgText = [_text.internalTextView.textStorage getPlainString];
    NSString *trimedStr = [_msgText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_msgText.length > 0 && trimedStr.length > 0) {
        //ODMessage* msg = [[ODMessage alloc]init];
        ODPresentGiftMsg* msg = [[ODPresentGiftMsg alloc]init];
        msg.giftImgPath = (i % 2) ? [[NSBundle mainBundle] pathForResource:@"fafengche.png" ofType:nil]: [[NSBundle mainBundle] pathForResource:@"xiaohuangya.png" ofType:nil];
        msg.messageType = kODMessageType_GiftPresent;
        msg.fromNick = @"常平";
        msg.toNick = @"applechang"
        
//        if ([_logic checkMsg:message room:self.room]) {
//            [_logic sendMsg:message];
//            _text.text = @"";
//            ODChatViewController* chat = (ODChatViewController *)[self.roomContext loadPluginById:ODRoomPluginId_Chat];
//            if (chat && [chat respondsToSelector:@selector(onSendMsg:)]) {
//                [chat onSendMsg:message];
//            }
//            //[self hideFloatingBoard];
//            //[_text resignFirstResponder];
//            GLiveLogDev("发送聊天消息：%s", [_msgText UTF8String]);
//            return YES;
//        }
    }
    return NO;
}



- (void)doHideKeyboardAni:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    [self onHideKeyboardAniSet];
    
    [UIView commitAnimations];
    /*
    [UIView animateWithDuration:duration animations:^{
        [weakSelf onHideKeyboardAniSet];
    } completion:^(BOOL finished) {
    }];
     */
}

- (void)doShowKeyboardAni:(NSTimeInterval)duration
           keyboardHeight:(CGFloat)height {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    [self onShowKeyboardAniSet:height];
    
    [UIView commitAnimations];
    /*
    [UIView animateWithDuration:duration animations:^{
        [weakSelf onShowKeyboardAniSet:height];
    } completion:^(BOOL finished) {
    }];
     */
}

//OCS_PLUGIN_METHODS_END
//#endif

@end
