//
//  UIImage+labGrayImage.h
//  QZCommonLib
//
//  Created by huiping on 16/7/25.
//  Copyright © 2016年 enigmaliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (labGrayImage)
/** labGrayImage
 *  Lab模式滤镜生成灰度图
 *
 *  PS步骤：
 *  1、将图片的RGB模式转换为LAB模式
 *  2、复制明度通道数据，新建一个图层
 *  3、调整图层不透明度为原来的90%
 *  4、合并原图层和新图层
 **/
- (UIImage*)labGrayImage;
@end
