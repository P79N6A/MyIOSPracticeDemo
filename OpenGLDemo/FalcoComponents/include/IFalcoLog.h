//
//  IFalcoLog.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/12.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@protocol IFalcoLog <IFalcoObject>

@required
// 最终版本输出
+ (void)log_Final:(NSString *)module msg:(NSString *)msg;
// 染色号码输出
+ (void)log_Dye:(NSString *)module msg:(NSString *)msg;
// 开发版本输出
+ (void)log_Dev:(NSString *)module msg:(NSString *)msg;
// 调试过程输出
+ (void)log_Debug:(NSString *)module msg:(NSString *)msg;

@end
