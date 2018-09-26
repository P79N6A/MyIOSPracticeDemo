//
// Created by jichao on 2017/4/30.
// Copyright (c) 2017 tencent. All rights reserved.
//

#import "ODMessageCustomElem.h"


@implementation ODMessageCustomElem

//#if ENABLE_OCS_PLUGIN_REPLACE_METHODS
//OCS_PLUGIN_METHODS_START
-(instancetype)initWithData:(NSString *)data desc:(NSString *)desc ext:(NSString*)ext {
    if (self = [super init]) {
        self.data = data;
        self.desc = desc;
        self.ext = ext;
    }
    return self;
}
//OCS_PLUGIN_METHODS_END
//#endif

@end
