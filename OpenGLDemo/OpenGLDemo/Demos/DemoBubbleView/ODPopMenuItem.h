//
//  ODPopMenuItem.h
//  ODApp
//
//  Created by britayin on 2017/6/2.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ODPopMenuItem : NSObject

@property (nonatomic, assign) NSInteger menuId;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *name;

+ (instancetype)itemWithId:(NSInteger)menuId icon:(UIImage *)icon name:(NSString *)name;

@end
