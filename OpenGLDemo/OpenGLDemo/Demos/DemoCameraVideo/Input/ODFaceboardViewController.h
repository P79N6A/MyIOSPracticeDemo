//
//  ODFaceboardViewController.h
//  HuaYang
//
//  Created by johnxguo on 2017/5/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODOCSUtil.h"

#if ENABLE_OCS_DYNAMIC_CLASS
@protocol ODFaceboardDelegate <NSObject>

OCS_PROTOCOL_DYNAMIC_FLAG

- (void)addFace:(int)index;
- (void)removeFace;
- (void)onSendBtnClick;

@end


@interface ODFaceboardViewController : UIViewController

@property (nonatomic, weak) id<ODFaceboardDelegate> delegate;
@property (nonatomic, assign, readonly) int height;

- (void)setSendButtonEnable:(BOOL)enable;

@end
#endif
