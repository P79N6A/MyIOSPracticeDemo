//
// Created by jichao on 2017/4/30.
// Copyright (c) 2017 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODMessageCustomElem : NSObject
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* data;
@property (nonatomic, strong) NSString* ext;
-(instancetype)initWithData:(NSString*)data desc:(NSString*)desc ext:(NSString*)ext;
@end