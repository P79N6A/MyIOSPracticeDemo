//
//  PLActionSheetView.h
//  HuaYang
//
//  Created by kivensong on 16/3/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PLActionBtnIndex)
{
    PLActionBtnIndex_Cancel = -1,
};

@interface PLActionSheetView : UIView
- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray *)titleArray;

- (void)showActionSheet;
- (void)hideActionSheet;
- (void)setButtonTile:(NSString*)title atIndex:(int)index;
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;
- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size atIndex:(int)index;
- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size;

@property (nonatomic,copy ) void (^completeBlock) (NSInteger buttonIndex);
- (void)showActionSheetWithCompleteBlock:(void (^)(NSInteger buttonIndex))complete;

@end

@protocol PLActionSheetDelegate <NSObject>
@optional
- (void)actionSheetCancel:(PLActionSheetView *)actionSheet;
- (void)actionSheet:(PLActionSheetView *)sheet clickedButtonIndex:(NSInteger)buttonIndex;

@end


