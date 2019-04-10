//
//  CommonDefine.h
//  Common
//
//  Created by 张晏兵 on 14-10-10.
//  Copyright (c) 2015年 tencent. All rights reserved.
// 

#ifndef __COMMON_DEFINE_H__
#define __COMMON_DEFINE_H__

typedef char			        INT8;
typedef short			        INT16;
typedef int                     INT32;
typedef unsigned char	        UINT8;
typedef unsigned short	        UINT16;
typedef unsigned int            UINT32;
typedef unsigned long long		UINT64;
typedef long long				INT64;


#ifndef MIN
#define MIN(A,B)	((A) < (B) ? (A) : (B))
#endif

#ifndef MAX
#define MAX(A,B)	((A) > (B) ? (A) : (B))
#endif

//获取系统版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif  //__COMMON_DEFINE_H__
