//
//  IResDownloadMgr.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/18.
//  Copyright © 2018年 tencent. All rights reserved.
//
//  把打包的资源网络化（减包必备）
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"

// 下载状态
typedef NS_ENUM(NSUInteger, FALCO_PACKRESLOAD_STATUS) {
    FALCO_PACKRESLOAD_STATUS_NOTSTART = 0,        //从没有被下载过
    FALCO_PACKRESLOAD_STATUS_WAIT = 1,            //等待下载
    FALCO_PACKRESLOAD_STATUS_DOWNLOADING = 2,     //下载中
    FALCO_PACKRESLOAD_STATUS_UNZIPING = 3,        //解压中
    FALCO_PACKRESLOAD_STATUS_SUCCESS = 4,         //成功
    FALCO_PACKRESLOAD_STATUS_FAIL = 5,            //失败
    FALCO_PACKRESLOAD_STATUS_CANCELLED = 6,          //取消
    FALCO_PACKRESLOAD_STATUS_DOWNLOADED = 7          //早已存在文件缓存里
};

// 失败原因
typedef NS_ENUM(NSUInteger, FALCO_PACKRESLOAD_ERR) {
    FALCO_PACKRESLOAD_ERR_DOWNLOAD = 0,        //下载失败
    FALCO_PACKRESLOAD_ERR_MD5_VERIFY = 1,      //MD5校验失败
    FALCO_PACKRESLOAD_ERR_UNZIP = 2,           //解压失败
    FALCO_PACKRESLOAD_ERR_UNZIP_VERIFY = 3,    //解压文件校验失败
    FALCO_PACKRESLOAD_ERR_SNAPSHOT = 4,        //创建SnapShot文件失败
};

@protocol IFalcoPackResInfo <IFalcoObject>

@required
- (void)setDataWithUrl:(NSString *)url
                   md5:(NSString *)md5
            unzipFiles:(NSArray *)unzipFiles
       ResDownloadTime:(int)downloadTime;

- (void)setZipSavePath:(NSString *)zipSavePath
          unZipDirPath:(NSString *)unZipDirPath;

- (NSString *)url;// 资源url
- (NSString *)md5;// 资源包的md5
- (NSArray *)unzipFiles;// 解压后的文件/文件夹列表，用于校验解压是否完全
- (int)downloadTime;// 自动下载时机
- (NSString *)zipSavePath;// zip文件下载保存路径
- (NSString *)unZipDirPath;// 解压后的文件夹路径

@end


@protocol IFalcoPackResDownloadDelegate <IFalcoObject>

@optional
-(void)onResloadStart:(int)businesstype; // 资源包开始加载

@optional
-(void)onResloadSuccess:(int)businesstype resInfo:(id<IFalcoPackResInfo>)info; // 资源加载完成

@optional
-(void)onResloadFail:(int)businesstype; // 资源包加载失败

@optional
-(void)onResloadCannelled:(int)businesstype; // 资源包加载取消

@end



@protocol IFalcoPackResLoader <IFalcoObject>

// 注册 业务的打包资源 格式:<int:id<IFalcoPackResInfo>>
- (void)registePackResInfoDic:(NSMutableDictionary *)resInfoDic;

// 业务对应网络资源信息
-(id<IFalcoPackResInfo>)getNetResInfo_bybusinessType:(int)type;

// 对应业务的资源包是否已下载
-(BOOL)hasDownloaded:(int)businesstype;

// 下载单个资源包
-(void)downLoadRes:(int)businesstype delegate:(id<IFalcoPackResDownloadDelegate>)delegate;

// 解除对应业务资源包的监听
-(void)removeDelegate:(id<IFalcoPackResDownloadDelegate>)delegate ByType:(int)businesstype;

// 加载-downloadTime指定时间点-的资源包
-(void)load_WithResDownloadTime:(int)downloadTime;

// 删除本地版本太老的资源包
-(void)removeOldVersionFile:(NSString *)unzipDirPath;

@end


