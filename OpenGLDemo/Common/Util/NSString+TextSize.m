#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "NSString+TextSize.m"
#pragma clang diagnostic pop


//
//  NSString+TextSize.m
//  ttpic
//
//  Created by dreamqian on 14/12/24.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "NSString+TextSize.h"


@implementation NSString (TextSize)

- (CGSize)sizeWithFontV2:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;

    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

@end
