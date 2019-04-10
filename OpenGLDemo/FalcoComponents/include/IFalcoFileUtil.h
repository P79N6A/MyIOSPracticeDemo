//
//  IFalcoFileUtil.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2019/1/3.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"

@protocol IFalcoFileUtil <IFalcoObject>

@required
// 文件路径是否为软连接
+ (BOOL)isSymbolicLink:(NSString *)path;

// 遍历文件夹时 需要避开的子文件名
+ (BOOL)shouldIgnoreFile:(NSString *)fileName;

// 如果目录不存在——创建目录
+ (BOOL)createDirectoryIfNeed:(NSString *)path;

// get the md5 string for a file
+ (NSString *)fileMD5:(NSString *)filePath;

+ (NSString*)urlEncode:(NSString*)url onlyLinkSymbol:(BOOL)yn;

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;

+ (BOOL)unzipFile:(NSString *)file toPath:(NSString *)toPath;

@end
