//
// Created by jichao on 2017/4/30.
// Copyright (c) 2017 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODMessageFaceElem : NSObject
@property (nonatomic, strong) NSNumber* index;
@property (nonatomic, strong) NSString* data;
-(instancetype)initWithIndex:(NSNumber*)index data:(NSString*)data;
@end