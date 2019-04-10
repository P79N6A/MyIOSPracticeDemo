//
//  IFalcoGrowingTextView.h
//  FalcoComponents
//
//  Created by johnxguo on 2019/1/11.
//  Copyright © 2019年 Carly 黄. All rights reserved.
//

#ifndef IFalcoGrowingTextView_h
#define IFalcoGrowingTextView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IFalcoComponent.h"

@protocol IFalcoGrowingTextViewDelegate <NSObject>
@optional
- (void)growingTextViewDidChange:(id)growingTextView;
- (void)growingTextViewWillChangeHeight:(float)height;
- (BOOL)growingTextViewShouldReturn;
- (BOOL)growingTextViewShouldBeginEditing;
@end

@protocol IFalcoGrowingTextView <IFalcoObject>
@required
- (UIView*)getView;
- (UITextView*)getTextView;
- (void)setMinNumberOfLines:(int)minNumberOfLines;
- (void)setMaxNumberOfLines:(int)maxNumberOfLines;
- (void)setDelegate:(id<IFalcoGrowingTextViewDelegate>)delegate;
- (void)setAnimationDuration:(NSTimeInterval)duration;
- (void)setContentInset:(UIEdgeInsets)inset;
- (void)setPlaceholder:(NSString*)placeholder;
- (void)setPlaceholderColor:(UIColor*)color;
- (void)setText:(NSString*)text;
- (void)refreshHeight;
- (void)setFont:(UIFont *)font;
- (void)setMaxLength:(NSUInteger)length countOnByte:(BOOL)isCountOnByte;  // 设置最大长度：isCountOnByte 【0: UTF8  1:字符数（1个汉字=2个英文）】
- (void)setForbiddenStr:(NSString*)forbiddenStr;
- (void)checkLength;
@end

#endif /* IFalcoGrowingTextView_h */
