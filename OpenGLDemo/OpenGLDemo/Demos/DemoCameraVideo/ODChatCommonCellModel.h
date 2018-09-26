//Created by applechang
//detail: 娱乐模式下，公屏聊天tableview cell model 数据提供类
//Copyright (c) 2017/11/17 applechang. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kODChatTVCellDefHeight 20 //每行固定高度
#define kGiftImageDefHeight 24    //礼物图片缺省高度
#define kGiftImageDefWidht  24    //礼物图片缺省宽度
//#define KFacialSizeWidth  24.0    //表情的长宽
//#define KFacialSizeHeight 24.0
#define MAX_WIDTH (SCREEN_WIDTH-2.0*15)  //行宽

#define ODTlibGetAValue(argb) (unsigned char)((argb) >> 24)
#define ODTlibGetRValue(argb) (unsigned char)((argb) >> 16)
#define ODTlibGetGValue(argb) (unsigned char)((argb) >> 8)
#define ODTlibGetBValue(argb) (unsigned char)(argb)

@class ODMessage;

@interface ODChatCellSubRenderObject : NSObject
@property (nonatomic, assign) CGRect rcDrawArea;
@property (nonatomic, assign) int    lineNo; //该渲染item所处的行
- (void)draw:(UIView*)cell withRect:(CGRect)rcCell;
- (BOOL)hitTest:(CGPoint)pt;
@end

@interface ODChatCellTextRenderObject : ODChatCellSubRenderObject
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, retain) UIColor  *textColor;
@property (nonatomic, retain) UIFont   *textFont;
@end

@interface ODChatCellImageRenderObject : ODChatCellSubRenderObject
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIView   *asyncImageView;
@property (nonatomic, assign) BOOL     asyncLoad;
@end

//每个富文本里可能包含多个绘制项
@interface ODChatTVCellSubRichitem : NSObject
@property (nonatomic, retain) NSMutableArray<ODChatCellSubRenderObject*> *renderObjects;
-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)width
              withLineHeight:(CGFloat)height;
- (BOOL)hitTest:(CGPoint)pt;
@end

@interface ODChatTVCellTextSubRichitem : ODChatTVCellSubRichitem
@property (nonatomic, retain) NSString *originText;
@property (nonatomic, retain) UIColor  *textColor;
@property (nonatomic, retain) UIFont   *textFont;
-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)width
              withLineHeight:(CGFloat)height;
@end

@interface ODChatTVCellNickNameItem : ODChatTVCellTextSubRichitem
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* nickname;
@property (nonatomic, copy) void (^itemClickBlock)();
- (BOOL)hitTest:(CGPoint)pt;
@end

@interface ODChatTVCellImageSubRichitem : ODChatTVCellSubRichitem
@property (nonatomic, retain) UIImage  *image;
@property (nonatomic, assign) CGSize   imageSize;
@property (nonatomic, retain) UIView   *asyncImageView;
@property (nonatomic, assign) BOOL     asyncLoad;

-(CGRect)createRenderObjects:(CGRect)rcPreObject
               withLineWidth:(CGFloat)width
              withLineHeight:(CGFloat)height;
//+(ODChatTVCellImageSubRichitem*) newImageItem:(NSString *)imgPath withSize:(CGSize)dstSize;
@end

@class ODMessage;

//每个cell可能包括多行，每行可能包括多个富文本(主要是文本、图像)
@interface ODChatCommonCellModel : NSObject
@property (nonatomic, retain) UIImage  *finalImage;
@property (nonatomic, assign) int totalLine;
@property (nonatomic, retain) NSMutableArray<ODChatTVCellSubRichitem*>* richItems;
- (void)draw:(UIView*)cell withRect:(CGRect)rcCell;
- (void)addItem:(ODChatTVCellSubRichitem *)item;
- (void)addItemArray:(NSArray *)items;
- (BOOL)hitTest:(CGPoint)pt;
- (void)preprocessCell;
- (void)setCellWidth:(CGFloat)width;
- (CGFloat)getCellWidth;

- (CGFloat)getCellHeight;
- (void)setLineHeight:(CGFloat)lineHeight;
@end

@interface ODChatGiftCellModel : ODChatCommonCellModel
@end

@interface ODChatHintCellModel : ODChatCommonCellModel
-(instancetype)initWithWidth:(CGFloat)width;
@end

