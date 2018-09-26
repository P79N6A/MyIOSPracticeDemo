//Created by applechang
//detail: 豪华礼物动画控件demo，业务层如果觉得名字不适合，请另取
//Copyright (c) 2017/5/2 applechang. All rights reserved.

//请@johnxguo实现该类的MRC及OCS
#import "LOTCacheProvider.h"
@class ODLOTImageReplaceMgr;

typedef NS_ENUM(NSInteger, GLIVEMP4PLAYERRORCODE)
{
    GLIVEMP4_ERROR_HEAD_ERROR = 1,
    GLIVEMP4_ERROR_RES_NOT_EXIST = 2,
    GLIVEMP4_ERROR_PLAY_ERROR = 3,
    GLIVEMP4_ERROR_DOWNLOAD_ERROR = 4,
    GLIVEMP4_ERROR_RES_ERROR = 5,
};

@protocol ODH264ProtocolDelegate <NSObject>

//开始播放回调
- (void)onODH264GiftStart;

//结束播放回调
- (void)onODH264GiftEnd;

////播放出错回调
- (void)onODH264GiftError:(GLIVEMP4PLAYERRORCODE)errorCode;

@end



@interface ODGiftH264ViewController : UIViewController<UIWebViewDelegate>

//@property(nonatomic,weak) id<ODH264ProtocolDelegate> h264Delegate;
//该接口是参考NOW直播的接口，我们可以根据协议数据，重新定义设计
//- (void)prePlayFile:(NSString *)rootRes withDic:(NSDictionary *)dict iscar:(BOOL)iscar;
- (void)PlayTestFile; //applechang test

//播放文件URL(file://+path) 或者 网络URL(http://或者https://)
- (void)play:(NSURL *)url;
- (void)play:(NSURL *)url customJson:(NSString *)customJson;

- (void)stopPlay;

+ (ODGiftH264ViewController*)sharedInstance;

@end

@interface ODLOTImageReplaceMgr : NSObject <LOTImageCache>

- (void)replaceImagePath:(NSString *)path byImagePath:(NSString *)replacePath;

- (void)replaceImagePath:(NSString *)path byImage:(UIImage *)image;

- (void)removePathReplace:(NSString *)path;
- (void)clear;

@end

