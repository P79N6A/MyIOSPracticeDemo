//
//  PLUtilDefaultImage.h
//  HuaYang
//
//  Created by Andre on 16/4/7.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYImage.h"

@interface PLUtilDefaultImage : NSObject
+ (UIImage*)head30;
+ (UIImage*)head40;
+ (UIImage*)head50;
+ (UIImage*)head70;
+ (UIImage*)head375; //该尺寸没有缓存
+ (UIImage*)gift;
+ (UIImage*)huadouSelectImage;
+ (UIImage*)huadouUnSelectImage;

+ (UIImage*)giftDefaultImage:(NSString*)partPath;
+ (YYImage*)giftDefaultApngImage:(NSString*)partPath;
@end
