//
//  ODFaceTextAttachment.h
//  HuaYang
//
//  Created by johnxguo on 2017/5/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODOCSUtil.h"

#if ENABLE_OCS_DYNAMIC_CLASS
@interface ODFaceTextAttachment : NSTextAttachment

- (void)setTag:(NSString *)tag;
- (NSString *)tag;
- (void)setImgSize:(CGSize)imgSize;
- (CGSize)imgSize;

@end
#endif
