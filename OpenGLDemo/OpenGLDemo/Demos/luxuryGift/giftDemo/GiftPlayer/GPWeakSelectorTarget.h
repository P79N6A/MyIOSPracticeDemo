
#import <Foundation/Foundation.h>

@interface GPWeakSelectorTarget : NSObject

@property (readonly, nonatomic, weak) id target;
@property (readonly, nonatomic) SEL targetSelector;
@property (readonly, nonatomic) SEL handleSelector;

- (instancetype)initWithTarget:(id)target targetSelector:(SEL)targetSelector;

- (BOOL)sendMessageToTarget:(id)param;

@end
