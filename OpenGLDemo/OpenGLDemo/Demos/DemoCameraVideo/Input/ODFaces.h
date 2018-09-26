//
//  ODFaces.h
//  HuaYang
//
//  Created by johnxguo on 2017/5/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ODOCSUtil.h"

#if ENABLE_OCS_DYNAMIC_CLASS
@interface ODFaces : NSObject

+(instancetype)shareInstance;
- (int) count;
- (NSString*) name_by_index:(int)index;
- (NSString*) path_by_index:(int)index;
- (UIImage*)  img_by_index :(int)index;
- (UIImage*)  img_by_name  :(NSString*)name;
- (int)       index_by_Name:(NSString*)name;

@end
#endif
