//
//  ODFaces.m
//  HuaYang
//
//  Created by johnxguo on 2017/5/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

// johnxguo OCS file mark

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag.
#endif

#import "ODFaces.h"
#import "UIImage+ODHelper.h"
#import "ODResDownloadMgr.h"
#import "ODSingletonMgr.h"


//#define s_sf_count 84
//
//static const NSString *s_sf_names[] = {
//    @"惊讶",@"撇嘴",@"色",@"发呆",@"得意",@"流泪",@"害羞",
//    @"睡",@"大哭",@"尴尬",@"发怒",@"呲牙",@"微笑",@"难过",
//    @"酷",@"冷汗",@"抓狂",@"吐",@"偷笑",@"可爱",@"白眼",
//    @"傲慢",@"饥饿",@"困",@"惊恐",@"流汗",@"憨笑",@"大兵",
//    @"奋斗",@"疑问",@"嘘",@"晕",@"折磨",@"衰",@"骷髅",
//    @"再见",@"跑",@"发抖",@"爱情",@"跳跳",@"晕倒",@"Q妹",
//    @"猪头",@"拥抱",@"蛋糕",@"便便",@"玫瑰",@"凋谢",@"示爱",
//    @"爱心",@"礼物",@"太阳",@"月亮",@"强",@"弱",@"握手",
//    @"胜利",@"飞吻",@"西瓜",@"抠鼻",@"鼓掌",@"糗大了",@"坏笑",
//    @"左哼哼",@"右哼哼",@"哈欠",@"鄙视",@"委屈",@"快哭了",@"阴险",
//    @"亲亲",@"吓",@"可怜",@"菜刀",@"啤酒",@"车",@"抱拳",
//    @"勾引",@"拳头",@"差劲",@"爱你",@"不",@"好",@"药"
//};
//
//static const NSDictionary* s_sf_name_index_map = nil;

#if ENABLE_OCS_DYNAMIC_CLASS
@interface ODFaces()

@property (nonatomic, strong) NSMutableArray * s_sf_names;
@property (nonatomic, strong) NSDictionary *s_sf_name_index_map;

@end

@implementation ODFaces

//#if ENABLE_OCS_PLUGIN_REPLACE_METHODS && (!defined ODOCS_SWITCH_A)
//OCS_PLUGIN_METHODS_START
OCS_CLASS_DYNAMIC_FLAG

+(instancetype)shareInstance {
    return [ODSingletonMgr sharedODFace:ODFaces.class];
}

-(void)dealloc
{
    if (self.s_sf_names) {
        [self.s_sf_names removeAllObjects];
        [self.s_sf_names release];
        self.s_sf_names = nil;
    }
    self.s_sf_name_index_map = nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.s_sf_names = [[NSMutableArray alloc] initWithArray:@[
            @"惊讶",@"撇嘴",@"色",@"发呆",@"得意",@"流泪",@"害羞",
            @"睡",@"大哭",@"尴尬",@"发怒",@"呲牙",@"微笑",@"难过",
            @"酷",@"冷汗",@"抓狂",@"吐",@"偷笑",@"可爱",@"白眼",
            @"傲慢",@"饥饿",@"困",@"惊恐",@"流汗",@"憨笑",@"大兵",
            @"奋斗",@"疑问",@"嘘",@"晕",@"折磨",@"衰",@"骷髅",
            @"再见",@"跑",@"发抖",@"爱情",@"跳跳",@"晕倒",@"Q妹",
            @"猪头",@"拥抱",@"蛋糕",@"便便",@"玫瑰",@"凋谢",@"示爱",
            @"爱心",@"礼物",@"太阳",@"月亮",@"强",@"弱",@"握手",
            @"胜利",@"飞吻",@"西瓜",@"抠鼻",@"鼓掌",@"糗大了",@"坏笑",
            @"左哼哼",@"右哼哼",@"哈欠",@"鄙视",@"委屈",@"快哭了",@"阴险",
            @"亲亲",@"吓",@"可怜",@"菜刀",@"啤酒",@"车",@"抱拳",
            @"勾引",@"拳头",@"差劲",@"爱你",@"不",@"好",@"药"
        ]];
    }
    return self;
}

- (void) init_name_index_map {
    if (self.s_sf_name_index_map) {
        return;
    }
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i = 0; i < self.s_sf_names.count; i++) {
        dict[self.s_sf_names[i]] = [NSNumber numberWithInt:i];
    }
    
    self.s_sf_name_index_map = [NSDictionary dictionaryWithDictionary:dict];
}

- (int) count {
    return (int)self.s_sf_names.count;
}

- (NSString*) name_by_index:(int)index {
    return [[((NSString *)self.s_sf_names[index]) copy] autorelease];
}

- (NSString*) path_by_index:(int)index {
    ODNetResInfo * info = [[ODResDownloadMgr shareInstance] getODNetResInfo_bybusinessType:TYPE_CHAT_FACES];
    if (info) {
        return [NSString stringWithFormat:@"%@/ODFaces/od_emotion_%d.png", info.unZipDirPath, index];
    }
    return nil;
}

- (UIImage *) img_by_index:(int)index {
    NSString * path = [self path_by_index:index];
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return nil;
    }
}

- (UIImage*) img_by_name:(NSString*)name {
    return [self img_by_index:[self index_by_Name:name]];
}

- (int) index_by_Name:(NSString*)name {
    [self init_name_index_map];
    return [self.s_sf_name_index_map[name] intValue];
}

//OCS_PLUGIN_METHODS_END
//#endif

@end
#endif
