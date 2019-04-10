
#import "ODPopoverPluginViewController.h"
#import "ODPopMenuItem.h"

@class ODPopMenuItem;
@protocol ODPopMenuViewDelegate <NSObject>
@required
- (void)didMenuSelected:(ODPopMenuItem *)item atIndex:(NSInteger)index;
@end

@protocol ODPopTipsViewDelegate <NSObject>
@required
- (void)tipsDisappear;

@end

@interface ODPopBubbleViewController : ODPopoverPluginViewController
@property (nonatomic, assign) BOOL singleLineTips;  //是否是单行提示
- (void)showIn:(CGPoint)point menus:(NSArray *)menuData isUp:(bool)isUp;
- (void)hideAfterSeconds:(NSTimeInterval)seconds;
- (BOOL)isShowing;
@end
