//
//  PLAudioVideoAccessUtil.m
//  HuaYang
//
//  Created by maxwellpang on 2017/10/24.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "PLAudioVideoAccessUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation PLAudioVideoAccessUtil

+ (void)requestCamPermission:(void (^)(BOOL granted))handler {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        const AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusAuthorized == status) {
            handler(YES);
            
        } else if (AVAuthorizationStatusNotDetermined != status) {
            handler(NO);
            
        } else {
            __typeof(handler) copiedHandler = [handler copy];
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if([NSThread isMainThread]) {
                    copiedHandler(granted);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        copiedHandler(granted);
                    });
                }
            }];
        }
    } else {
        handler(NO);
    }
}

+ (void)showCamDeniedAlertView:(id<PLAlertViewDelegate>)alertViewDelegate {
    PLAlertView *alert = [[PLAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"ID_CAMERA_AUTHOR", @"") delegate:alertViewDelegate cancelButtonTitle:NSLocalizedString(@"ID_ALERT_CANCEL", @"") otherButtonTitles:NSLocalizedString(@"ID_SETTING_TITLE", @""), nil];
    alert.tag = CAMERA_ALERT_TAG;
    [alert setButtonFocusAtIndex:1];
    [alert show];
}

+ (void)requestMicPermission:(void (^)(BOOL granted))handler {
    
    const AVAuthorizationStatus micStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (AVAuthorizationStatusAuthorized == micStatus) {
        handler(YES);
        
    } else if (AVAuthorizationStatusNotDetermined != micStatus) {
        handler(NO);
        
    } else {
        __typeof(handler) copiedHandler = [handler copy];
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if([NSThread isMainThread]) {
                copiedHandler(granted);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^() {
                    copiedHandler(granted);
                });
            }
        }];
    }

}

+ (void)showMicDeniedAlertView:(id<PLAlertViewDelegate>)alertViewDelegate {
    PLAlertView *alert = [[PLAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"ID_AUDIO_AUTHOR", @"") delegate:alertViewDelegate cancelButtonTitle:NSLocalizedString(@"ID_ALERT_CANCEL", @"") otherButtonTitles:NSLocalizedString(@"ID_SETTING_TITLE", @""), nil];
    alert.tag = MIC_ALERT_TAG;
    [alert setButtonFocusAtIndex:1];
    [alert show];
}

@end
