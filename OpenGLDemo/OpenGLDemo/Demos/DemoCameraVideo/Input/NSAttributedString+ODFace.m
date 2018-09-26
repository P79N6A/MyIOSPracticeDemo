//
//  NSAttributedString+ODFace.m
//  HuaYang
//
//  Created by johnxguo on 2017/5/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

// johnxguo OCS file mark

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import <UIKit/UIKit.h>
#import "NSAttributedString+ODFace.h"
#import "ODFaceTextAttachment.h"
#import "ODOCSUtil.h"


@implementation NSAttributedString (ODFace)

#if ENABLE_OCS_PLUGIN_REPLACE_METHODS && (!defined ODOCS_SWITCH_A)
OCS_PLUGIN_METHODS_START

- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    [self doEnumString:plainString];
    return plainString;
}

- (NSInteger)onEnumString:(NSMutableString *)plainString
               value:(id)value
               range:(NSRange)range
                base:(NSInteger)base {
    if (value && [value isKindOfClass:[ODFaceTextAttachment class]]) {
        [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                   withString:((ODFaceTextAttachment *) value).tag];
        base = base + ((ODFaceTextAttachment *) value).tag.length - 1;
    }
    return base;
}

OCS_PLUGIN_METHODS_END
#endif

- (void)doEnumString:(NSMutableString *)plainString {
    __weak typeof(self) welf = self;
    __block NSInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName
                     inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      base = [welf onEnumString:plainString
                                          value:value
                                          range:range
                                           base:base];
                  }];
}


@end
