
#import <UIKit/UIKit.h>



@interface GLView : UIView

- (id) initWithFrame:(CGRect)frame;
- (void) display: (void *) overlay;



@property(nonatomic,strong) NSLock  *appActivityLock;
@property(nonatomic)        CGFloat  fps;
@property(nonatomic)        CGFloat  scaleFactor;


@end
