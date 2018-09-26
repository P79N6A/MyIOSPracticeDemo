//
//  BTConstraint.h
//  HuaYang
//
//  Created by britayin on 2017/5/16.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BTConstraint;

/**
 "让VFL的调用更简单"
 VFL用法参见 https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html
 */
@interface BTConstraint : NSObject

- (instancetype)initWithView:(UIView *)view;

/**
 添加一个VFL约束，可以调用多次来添加多个. 必须调用commit已生效.
 */
- (BTConstraint * (^)(NSString *vfl))vfl;

/**
 设置 NSLayoutFormatOptions，以最后一次设置为准
 */
- (BTConstraint * (^)(NSLayoutFormatOptions opts))opts;

/**
  所有用到的变量都应该加入
 */
- (BTConstraint * (^)(NSDictionary<NSString *,id> * metrics))metrics;

/**
 所有VFL中用到的View都应该加入
 */
- (BTConstraint * (^)(NSDictionary<NSString *, id> * views))views;

/**
 提交约束布局
 */
- (void (^)())commit;

- (void (^)())commitKeepOpt;

@end
