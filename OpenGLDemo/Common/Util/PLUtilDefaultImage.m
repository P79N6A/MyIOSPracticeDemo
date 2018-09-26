//
//  PLUtilDefaultImage.m
//  HuaYang
//
//  Created by Andre on 16/4/7.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PLUtilDefaultImage.h"
#import "PLUtilApp.h"

@implementation PLUtilDefaultImage
+ (UIImage*)head30
{
    static UIImage* headImage = nil;
    if (headImage == nil) {
        headImage = [UIImage loadImage:@"PersonalLive/Public/DefaultHead/defaulthead30.png"];
    }
    return headImage;
}

+ (UIImage*)head40
{
    static UIImage* headImage = nil;
    if (headImage == nil) {
        headImage = [UIImage loadImage:@"PersonalLive/Public/DefaultHead/defaulthead40.png"];
    }
    return headImage;
}

+ (UIImage*)head50
{
    static UIImage* headImage = nil;
    if (headImage == nil) {
        headImage = [UIImage loadImage:@"PersonalLive/Public/DefaultHead/defaulthead50.png"];
    }
    return headImage;
}

+ (UIImage*)head70
{
    static UIImage* headImage = nil;
    if (headImage == nil) {
        headImage = [UIImage loadImage:@"PersonalLive/Public/DefaultHead/defaulthead70.png"];
    }
    return headImage;
}

+ (UIImage*)head375
{
    return [UIImage loadImage:@"PersonalLive/Public/DefaultHead/defaulthead370.png"];
}

+ (UIImage*)gift
{
    static UIImage* giftImage = nil;
    if (giftImage == nil) {
        giftImage = [UIImage loadImage:@"PersonalLive/Gift/gift_default.png"];
    }
    return giftImage;
}

+ (UIImage *)huadouSelectImage
{
    static UIImage* huadouImage = nil;
    if (huadouImage == nil) {
        huadouImage = [UIImage loadImage:@"PersonalLive/Gift/huadou_select.png"];
    }
    return huadouImage;
}

+ (UIImage *)huadouUnSelectImage
{
    static UIImage* huadouImage = nil;
    if (huadouImage == nil) {
        huadouImage = [UIImage loadImage:@"PersonalLive/Gift/huadou_unselect.png"];
    }
    return huadouImage;
}

+ (UIImage*)giftDefaultImage:(NSString*)partPath
{
    return [PLUtilDefaultImage gift];
}

+ (YYImage*)giftDefaultApngImage:(NSString*)partPath
{
    if ([PLUtilApp isHandleUrlForIpv6] && partPath && partPath.length > 0) {
#if FINAL_RELEASE == 0
        LogFinal(@"giftDefaultImage", @"ipv6环境下获取默认apng图片");
#endif
        NSRange range = [partPath rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound && (range.location+1) < partPath.length) {
            return [YYImage imageNamed:[NSString stringWithFormat:@"Images/PersonalLive/gift_resource/%@", [partPath substringFromIndex:range.location+1]]];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
@end
