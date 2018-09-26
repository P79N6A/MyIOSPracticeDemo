//
//  ODFaceTextAttachment.m
//  HuaYang
//
//  Created by johnxguo on 2017/5/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

// johnxguo OCS file mark

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODFaceTextAttachment.h"
#import "ODOCSUtil.h"

#if ENABLE_OCS_DYNAMIC_CLASS
@implementation ODFaceTextAttachment {
    NSString *_tag;
    CGSize _imgSize;
}

//#if ENABLE_OCS_PLUGIN_REPLACE_METHODS && (!defined ODOCS_SWITCH_A)
//OCS_PLUGIN_METHODS_START
OCS_CLASS_DYNAMIC_FLAG

- (void)dealloc {
    if (_tag) {
        [_tag release];
        _tag = nil;
    }
    
    [super dealloc];
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, -5, _imgSize.width, _imgSize.height);
}

- (void)setTag:(NSString *)tag {
    if (_tag) {
        [_tag release];
        _tag = nil;
    }
    
    if (tag) {
        _tag = [tag copy];
    }
}

- (NSString *)tag {
    return _tag;
}

- (void)setImgSize:(CGSize)imgSize {
    _imgSize = imgSize;
}

- (CGSize)imgSize {
    return _imgSize;
}

//OCS_PLUGIN_METHODS_END
//#endif

@end
#endif
