//
//  NSString+TextSize.h
//  ttpic
//
//  Created by dreamqian on 14/12/24.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TextSize)

- (CGSize)sizeWithFontV2:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
