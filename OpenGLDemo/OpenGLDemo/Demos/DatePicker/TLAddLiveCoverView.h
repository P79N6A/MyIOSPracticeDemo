//
//  TLAddLiveCoverView.h
//  TencentLive
//
//  Created by Carly 黄 on 2019/1/31.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLProgramModel.h"

typedef NS_ENUM(NSUInteger, CoverImageStatus)
{
    CoverImageStatus_None,
    CoverImageStatus_Small,
    CoverImageStatus_Ready,
    CoverImageStatus_Ready_loadFail,
};

@protocol TLAddLiveCoverDelegate <NSObject>

- (void)onAddCoverClick;
- (void)onCoverChange:(NSString *)url;

@end

@interface TLAddLiveCoverView : UIControl

@property (nonatomic, assign) CoverImageStatus coverImgStatus;
@property (nonatomic, strong) NSString * coverUrl;

- (instancetype)init_withDelegate:(id<TLAddLiveCoverDelegate>)delegate type:(TLProgramType)type;

@end
