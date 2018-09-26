//
//  PLUtilShare.h
//  HuaYang
//
//  Created by hemanli on 16/6/22.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLShareItem.h"

@interface PLUtilShare : NSObject

+ (BOOL)shareWithItem:(PLShareItem *)shareItem channel:(PLShareChannel)channel;

+ (BOOL)shareWithItem:(PLShareItem *)shareItem channel:(PLShareChannel)channel isQZoneNew:(BOOL)isQzoneNew;
@end
