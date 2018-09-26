//
//  AutoHeightRichText.h
//  HuaYang
//
//  Created by johnxguo on 2017/5/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AHRichItem : NSObject
typedef enum _Type {
    None,
    Text,
    Image
} Type;
@property (nonatomic, copy) void (^click)();
@property (nonatomic, copy) NSString *schema;
@property (nonatomic, assign) BOOL canHide;
- (Type)type;
@end

@interface TextRichItem : AHRichItem
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, assign) BOOL endEllipsis;

- (TextRichItem *)initWithText:(NSString *)text
                     textColor:(UIColor *)color
                      textFont:(UIFont *)font
                   endEllipsis:(BOOL)endEllipsis
                         click:(void(^)())click
                        schema:(NSString *)schema;
@end

@interface ImageRichItem : AHRichItem
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, copy) NSString *url;
- (ImageRichItem *)initWithImage:(UIImage *)image
                       imageSize:(CGSize)size
                           click:(void (^)())click
                          schema:(NSString *)schema;
@end

@interface DrawItem : NSObject
@property (nonatomic, assign) CGRect rect;
@end

@interface TextDrawItem : DrawItem
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;
@end

@interface ImageDrawItem : DrawItem
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString *url;
@property (nonatomic ,assign) BOOL urlLoaded;
@end

@interface AutoHeightRichText : NSObject
@property (nonatomic, assign) int maxLine;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, retain, readonly) NSArray<DrawItem*> *drawItems;
- (void)addItem:(AHRichItem *)item;
- (void)clear;
- (BOOL)fit;
- (void)hit:(CGPoint)point;
- (void)lockFit;
- (void)unlockFit;
@end

