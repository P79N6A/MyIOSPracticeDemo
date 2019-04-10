#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "ODPopMenuItem.m"
#pragma clang diagnostic pop



#import "ODPopMenuItem.h"
@implementation ODPopMenuItem

- (void)dealloc
{
    self.icon = nil;
    self.name = nil;
}

+ (instancetype)itemWithId:(NSInteger)menuId icon:(UIImage *)icon name:(NSString *)name;
{
    ODPopMenuItem *item = [[ODPopMenuItem alloc] init];
    item.menuId = menuId;
    item.icon = icon;
    item.name = name;
    return item;
}

@end
