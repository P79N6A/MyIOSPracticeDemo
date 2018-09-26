//
//  ODChatCommonCell.h
//  HuaYang
//
//  Created by johnxguo on 2017/5/1.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoHeightRichText.h"

#define RIGHT_MARGIN_FIX 10
#define CELL_TOP_MARGIN 3
#define CELL_BOTTOM_MARGIN 3


@interface ODChatCommonCell : UITableViewCell

- (void)setItemRichText:(AutoHeightRichText *) richText;

@end
