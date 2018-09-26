
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
#import "GPWeakSelectorTarget.h"

@implementation GPWeakSelectorTarget

- (instancetype)initWithTarget:(id)target targetSelector:(SEL)sel {
    self = [super init];
    
    if (self) {
        _target = target;
        _targetSelector = sel;
    }
    
    return self;
}

- (BOOL)sendMessageToTarget:(id)param {
    id strongTarget = _target;
    
    if (strongTarget != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:_targetSelector withObject:param];
#pragma clang diagnostic pop
        
        return YES;
    }
    
    return NO;
}

- (SEL)handleSelector {
    return @selector(sendMessageToTarget:);
}

@end
