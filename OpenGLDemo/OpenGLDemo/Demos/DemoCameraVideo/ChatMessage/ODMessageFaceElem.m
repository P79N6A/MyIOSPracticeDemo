//
// Created by jichao on 2017/4/30.
// Copyright (c) 2017 tencent. All rights reserved.
//

#import "ODMessageFaceElem.h"


@implementation ODMessageFaceElem {

}

-(instancetype)initWithIndex:(NSNumber*)index data:(NSString *)data {
    if (self = [super init]) {
        self.index = index;
        self.data = data;
    }
    return self;
}
@end
