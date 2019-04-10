//
//  TLProgramModel.m
//  TencentLive
//
//  Created by nickyhuang on 2019/1/22.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import "TLProgramModel.h"

@implementation TLProgramInfoModel

- (id)init
{
    if (self = [super init]) {
        self.rptStrCoverArr = [NSMutableArray arrayWithCapacity:1];
        //self.uint32StartTs = 
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    TLProgramInfoModel *programInfoModel = [self.class allocWithZone:zone];
    programInfoModel.type = self.type;
    programInfoModel.strTitle = [self.strTitle copy];
    programInfoModel.uint32StartTs = self.uint32StartTs;
    programInfoModel.strDesc = self.strDesc;
    programInfoModel.rptStrCoverArr = [self.rptStrCoverArr mutableCopy];
    programInfoModel.uint32EndTs = self.uint32EndTs;
    programInfoModel.uint32CancelTs = self.uint32CancelTs;
    programInfoModel.uint32ShowNum = self.uint32ShowNum;
    return programInfoModel;
}

@end

@implementation TLProgramVideoModel


@end

@implementation TLProgramVoiceModel


@end


@implementation TLProgramModel

- (id)init
{
    if (self = [super init]) {
        self.programInfo = [TLProgramInfoModel new];
        self.typeVideo = [TLProgramVideoModel new];
        self.typeVoice = [TLProgramVoiceModel new];
    }
    return self;
}

@end
