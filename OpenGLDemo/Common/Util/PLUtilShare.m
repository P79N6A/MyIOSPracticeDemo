//
//  PLUtilShare.m
//  HuaYang
//
//  Created by hemanli on 16/6/22.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PLUtilShare.h"
#import "PLShareMgr.h"

@implementation PLUtilShare

+ (BOOL)shareWithItem:(PLShareItem *)shareItem channel:(PLShareChannel)channel
{
    return [self.class shareWithItem:shareItem channel:channel isQZoneNew:YES];
}

+ (BOOL)shareWithItem:(PLShareItem *)shareItem channel:(PLShareChannel)channel isQZoneNew:(BOOL)isQzoneNew
{
    switch (channel) {
        case PLShareChannel_QQ:
            return [[PLShareMgr shareInstance] shareToQQFriends:shareItem];
            break;
        case PLShareChannel_QZone:
            if(isQzoneNew)
                return [[PLShareMgr shareInstance] shareToQQZoneNew:shareItem];
            return [[PLShareMgr shareInstance] shareToQQZone:shareItem];
            break;
        case PLShareChannel_WeChat:
            return [[PLShareMgr shareInstance] shareToWeChatSession:shareItem];
            break;
        case PLShareChannel_WeChatTimeLine:
            return [[PLShareMgr shareInstance] shareToWeChatTimeline:shareItem];
            break;
        case PLShareChannel_SinaWeibo:
            return [[PLShareMgr shareInstance] shareToSinaWeibo:shareItem];
            break;
        default:
            return NO;
            break;
    }
}
@end
