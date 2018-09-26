//
// Created by jichao on 2017/4/27.
// Copyright (c) 2017 tencent. All rights reserved.
//
#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODMessage.h"




@implementation ODPresentGiftMsg

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    _giftImgPath = nil;
    _giverIdentityImgPath = nil;
    _receiverIdentityImgPath = nil;
}
@end

@implementation ODMessage
-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)dealloc
{
    [_nativeRep removeAllObjects];
    _nativeRep = nil;
    
    _jsonRep = nil;
    _toUid = nil;
    _toNick = nil;
    _fromUid = nil;
    _fromNick = nil;
    [super dealloc];
}
@end
