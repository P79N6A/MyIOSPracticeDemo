//
//  ViewDrawImageOpenGLES.h
//  OpenGLDemo
//
//  Created by Chris Hu on 16/3/25.
//  Copyright © 2016年 Chris Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, eGLiveVideoSrcType) {
    GLIVE_VIDEO_SRC_TYPE_NONE   = -1,     ///< 默认值，无意义
    GLIVE_VIDEO_SRC_TYPE_CAMERA = 0,   ///< 摄像头
    GLIVE_VIDEO_SRC_TYPE_SCREEN = 1,   ///< 屏幕分享
};
@interface ViewDrawImageOpenGLES : UIView

- (void)didDrawImageViaOpenGLES:(UIImage *)image;

@end
