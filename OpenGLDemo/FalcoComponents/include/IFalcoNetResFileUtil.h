//
//  IFalcoNetResFileUtil.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/18.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <UIKit/UIKit.h>
#import "IFalcoComponent.h"
#import "IFalcoBlock.h"
/*
@protocol IFalcoImgDownloadObserver <IFalcoObject>

@optional
// 下载图片成功通知
// key:url value:NSString = 图片URL
// key:image value:UIImage = 图片数据
- (void)downloadImageFinished:(NSDictionary*)dict;

// 下载图片失败通知
// key:url value:NSString = 图片URL
- (void)downLoadImageFail:(NSDictionary*)dict;

@end
*/

@protocol IFalcoFileDownloadObserver <NSObject>

@optional
-(void)onDownloadProgress:(float)progress userInfo:(id)userInfo; //下载进度

@optional
-(void)onDownloadSuccess:(NSString *)filePath userInfo:(id)userInfo; // 下载完成

@optional
-(void)onDownloadFail:(NSError *)error userInfo:(id)userInfo; // 下载失败

@end


@protocol IFalcoNetResFileUtil <IFalcoObject>

/*
//通过url获取缓存的图片，如果没有缓存，则返回nil
// 获取QQ打包的图片资源，resource/Defalut/imgPath
+ (UIImage *)imageFromCacheByUrl:(NSString *)url;

// 删除对url的缓存
+ (void)removeImgCacheByUrl:(NSString *)url;

// 同步获取url对应图片，注意，必需在子线程调用
+ (UIImage *)syncLoadImageFromUrl:(NSString *)url;

// 拉取url对应图片，observer回调
+ (void)imageFromUrl:(NSString *)url
            observer:(id<IFalcoImgDownloadObserver>)observer;

// 拉取url对应图片，block回调
+ (void)imageFromUrl:(NSString *)url
            callback:(void(^)(UIImage*))callback;

// 拉取url对应图片，block回调 retValue=UIImage
+ (void)loadNetImage:(NSString *)url onResult:(id<IFalcoBlock>)resultBlock;

// 拉取url集合对应的所有图片，全部下载完回调block
+ (void)loadNetImages:(NSSet *)urls onResult:(id<IFalcoBlock>)resultBlock;



// url对应文件是否下载完
+ (BOOL)isFileDownloaded_url:(NSString *)url;

// url => 默认本地文件存储地址
+ (NSString*)filePathForUrl:(NSString *)url;

// 获取url对应本地文件内容（如果文件未下载完，返回nil）
+ (NSData *)cacheFileFormUrl:(NSString *)url;

// 删除url对应本地文件
+ (void)removeFile:(NSString *)url;

// 下载文件， delegate回调，存放于默认文件路径
+ (void)downloadFileByUrl:(NSString *)url
                 delegate:(id<IFalcoFileDownloadObserver>)delegate
                 userInfo:(id)userInfo;
*/

// 下载文件， 指定存放地址filePath, delegate回调，存放于默认文件路径
+ (void)downloadFileByUrl:(NSString *)url
                 filePath:(NSString *)filePath
                 delegate:(id<IFalcoFileDownloadObserver>)delegate
                 userInfo:(id)userInfo;

/*
//加载网络资源文件，如果已经下载过，直接回调；如果没有下载过，会先去下载然后再回调； Block 回调结果 BlockResult.retValue就是filepath
+ (void)loadNetResFile:(NSString *)url
              onResult:(id<IFalcoBlock>)resultBlock;

//批量加载网络资源文件，会在所有资源就绪的情况下一起回调；任何一个文件下载失败都会中止并返回失败；Block 回调结果 BlockResult.retValue就是url-filepath的dictionary
+ (void)loadNetResFiles:(NSSet *)urlSet
               onResult:(id<IFalcoBlock>)resultBlock;
*/

@end
