//
//  PLUtilDeviceInfo.h
//  PersonalLive
//
//  Created by zuqingxie on 16/9/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLUtilDeviceInfo : NSObject

/*
 获取CPU的使用率
 引用:http://blog.csdn.net/x1135768777/article/details/11158713
 */
+ (float)getCPUUsage;

//返回当前进程使用的内存大小(MB)
+ (double)getUsedMemorySize;

//返回设备的物理内存大小(MB)
+ (uint32_t)getTotalMemorySize;

@end
