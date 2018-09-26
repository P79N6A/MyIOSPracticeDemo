//
//  PLAudioVideoAccessUtil.h
//  HuaYang
//
//  Created by maxwellpang on 2017/10/24.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAlertView.h"

#define CAMERA_ALERT_TAG 1014       // 摄像头权限申请提示
#define MIC_ALERT_TAG 1012

@interface PLAudioVideoAccessUtil : NSObject

+ (void)requestCamPermission:(void (^)(BOOL granted))handler;
+ (void)showCamDeniedAlertView:(id<PLAlertViewDelegate>)alertViewDelegate;

+ (void)requestMicPermission:(void (^)(BOOL granted))handler;
+ (void)showMicDeniedAlertView:(id<PLAlertViewDelegate>)alertViewDelegate;
@end
