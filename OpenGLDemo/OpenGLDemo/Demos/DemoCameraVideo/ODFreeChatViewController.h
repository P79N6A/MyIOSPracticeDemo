#import <UIKit/UIKit.h>
#import "ODMessage.h"

@interface ODFreeChatViewController : UIViewController

- (void)load:(UIView *)container;
- (void)showMsg:(ODMessage *)msg;
//- (void)onUserEnter:(ODMember *)user;
//- (void)onUserLeave:(ODMember *)user;
- (void)unload;

// 礼物消息
- (void)addGiftMsg:(NSString *)giftImgPath
     giverIdentity:(NSString *)giverIdentityImgPath
          giverUid:(UInt64)giverUid
         giverName:(NSString *)giverName
  receiverIdentity:(NSString *)receiverIdentityImgPath
       receiverUid:(UInt64)receiverUid
      receiverName:(NSString *)receiverName
           giftset:(NSUInteger)giftset
             combo:(NSUInteger)combo;

@end

