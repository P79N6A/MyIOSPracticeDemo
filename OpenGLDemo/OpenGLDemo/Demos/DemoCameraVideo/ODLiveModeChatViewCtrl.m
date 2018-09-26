
#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODLiveModeChatViewCtrl.h"
#import "ODLiveModeChatView.h"
#import "ODChatCommonCellNew.h"
#import "ODChatCommonCellModel.h"
#import "ODMessage.h"
#import "GLiveCPUMonitor.h"

#define CHAT_LEFT_MARGIN 10
#define OD_MAX_DEPOSITION_MSG_COUNT 50 //最大沉淀消息数
#define OD_MAX_RESERVE_MSG_COUNT    20 //超出清除，保留的消息数

@interface ODLiveModeChatViewCtrl (){
    ODLiveModeChatView* _chatView;
}
@end
    
@implementation ODLiveModeChatViewCtrl

- (void)viewDidLoad {
    _chatView = [[ODLiveModeChatView alloc]initWithFrame:self.view.frame];
    _chatView.hidden = FALSE;
    [self.view addSubview:_chatView];
}

-(void)onSendMsg:(ODMessage*)msg
{
    if (_chatView) {
        [_chatView onSendMsg:msg];
    }
}

@end
