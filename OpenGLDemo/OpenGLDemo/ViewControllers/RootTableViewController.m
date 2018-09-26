//
//  RootTableViewController.m
//  OpenGLDemo
//
//  Created by Chris Hu on 15/7/29.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import "RootTableViewController.h"
#import "ItemViewController.h"


#import "DemoClearColorViewController.h"
#import "DemoShaderViewController.h"
#import "DemoTriangleViewController.h"
#import "DemoDrawImageCoreGraphics.h"
#import "DemoDrawImageOpenGLES.h"
#import "OpenCameraGLESViewCtrl.h"
#import "UITableViewDemoCtrlNew.h"
#import "ODLiveModeChatViewCtrl.h"
#import "GLiveLuxuryGiftViewCtrl.h"
#import "ODFreeChatViewController.h"
#import "ODCloseLianmaiGuideViewCtrl.h"
#import "PicturePickerDemo.h"
#import "LottieShowViewController.h"
#import "RotateCameraImageCuberViewCtrl.h"
#import "MagicCuberViewCtrl.h"

typedef NS_ENUM(NSUInteger, DemoOpenGLES) {
    kDemoMagicImageCuber = 0,
    kDemoRotateCameraImageCuber,
    kDemoLottieAnimation,
    kDemoPicPicker,
    kDemoNormalUILayout,
    kDemoAnimationHitTest,
    kDemoMP4VideoPlayer,
    kDemoUITableView,
    kDemoClearColor,
    kDemoShader,
    kDemoTriangleViaShader,
    
    kDemoImageViaCoreGraphics,
    kDemoImageViaOpenGLES,
    kCameraVideoViaOpenGLES,
    
    kDemoPaintViaCoreGraphics,
    kDemoPaintViaOpenGLES,
    kDemoPaintViaOpenGLESTexture,
    kDemoPaintFilterViaOpenGLESTexture,
    
    kDemoCoreImageFilter,
    kDemoCoreImageOpenGLESFilter,
    
    kDemoGLKView,
};


@interface RootTableViewController ()

@property (nonatomic) NSArray *demosOpenGL;
@property (nonatomic) NSString *selectedItem;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"OpenGL Demos";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.demosOpenGL = @[
                         @"魔方",
                         @"旋转立方体图形",
                         @"IOSLottie动画练习",
                         @"IOS图片选取练习",
                         @"IOS控件布局练习",
                         @"动画控件HitTest",
                         @"豪华礼物播放Demo",
                         @"聊天面板Demo",
                         @"Clear Color",
                         @"Shader",
                         @"Draw Triangle via Shader",
                         @"Draw Image via Core Graphics",
                         @"静态图片demo",
                         @"相机视频Demo",
                         @"Paint via Core Graphics",
                         @"Paint via OpenGL ES",
                         @"Paint via OpenGL ES Texture",
                         @"Paint and Filter via OpenGLES Texture",
                         @"Core Image Filter",
                         @"Core Image and OpenGS ES Filter",
                         @"3D Transform",
                         @"GLKView Demo",
                         @"Paint via GLKView"
                         ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.demosOpenGL.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellOpenGL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.demosOpenGL[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kDemoMagicImageCuber) {
        MagicCuberViewCtrl* demo = [[MagicCuberViewCtrl alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"魔方";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoRotateCameraImageCuber) {
        RotateCameraImageCuberViewCtrl* demo = [[RotateCameraImageCuberViewCtrl alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"旋转立方体图形";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoLottieAnimation) {
        LottieShowViewController* demo = [[LottieShowViewController alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"LottieAnimationS";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoPicPicker) {
        PicturePickerDemo* demo = [[PicturePickerDemo alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"ImagerPicker";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoNormalUILayout) {
        ODCloseLianmaiGuideViewCtrl* demo = [[ODCloseLianmaiGuideViewCtrl alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"ODCloseLianmaiGuideViewCtrl";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoAnimationHitTest) {
        ODFreeChatViewController* demo = [[ODFreeChatViewController alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"ODFreeChatViewController";
        [self.navigationController pushViewController:demo animated:YES];
        return;
    }else if (indexPath.row == kDemoMP4VideoPlayer){
        GLiveLuxuryGiftViewCtrl* luxuryGiftCtrl = [[GLiveLuxuryGiftViewCtrl alloc]init];
        luxuryGiftCtrl.view.backgroundColor = [UIColor whiteColor];
        luxuryGiftCtrl.navigationItem.title = @"GLiveLuxuryGiftViewCtrl";
        [self.navigationController pushViewController:luxuryGiftCtrl animated:YES];
        return;
    }else if (indexPath.row == kDemoUITableView){
//        UITableViewDemo* demo = [[UITableViewDemo alloc]init];
//        demo.view.backgroundColor = [UIColor whiteColor];
//        demo.navigationItem.title = @"DemoUITableView";
//        [self.navigationController pushViewController:demo animated:YES];
//        UITableViewDemoNew* demo = [[UITableViewDemoNew alloc]init];
//        demo.view.backgroundColor = [UIColor whiteColor];
//        demo.navigationItem.title = @"DemoUITableViewNew";
//        [self.navigationController pushViewController:demo animated:YES];
        
        ODLiveModeChatViewCtrl* demo = [[ODLiveModeChatViewCtrl alloc]init];
        demo.view.backgroundColor = [UIColor whiteColor];
        demo.navigationItem.title = @"ODLiveModeChatViewCtrl";
        [self.navigationController pushViewController:demo animated:YES];
        
        return;
    }else if (indexPath.row == kDemoClearColor) {
        DemoClearColorViewController *demoClearColor = [[DemoClearColorViewController alloc] init];
        demoClearColor.view.backgroundColor = [UIColor whiteColor];
        demoClearColor.navigationItem.title = @"DemoClearColor";
        [self.navigationController pushViewController:demoClearColor animated:YES];
        return;
    } else if (indexPath.row == kDemoShader) {
        DemoShaderViewController *demoShader = [[DemoShaderViewController alloc] init];
        demoShader.view.backgroundColor = [UIColor whiteColor];
        demoShader.navigationItem.title = @"DemoShader";
        [self.navigationController pushViewController:demoShader animated:YES];
        return;
    } else if (indexPath.row == kDemoTriangleViaShader) {
        DemoTriangleViewController *demoTriangle = [[DemoTriangleViewController alloc] init];
        demoTriangle.view.backgroundColor = [UIColor whiteColor];
        demoTriangle.navigationItem.title = @"DemoTriangleViaShader";
        [self.navigationController pushViewController:demoTriangle animated:YES];
        return;
    } else if (indexPath.row == kDemoImageViaCoreGraphics) {
        DemoDrawImageCoreGraphics *demoDrawImageCoreGraphics = [DemoDrawImageCoreGraphics new];
        demoDrawImageCoreGraphics.view.backgroundColor = [UIColor whiteColor];
        demoDrawImageCoreGraphics.navigationItem.title = @"DemoDrawImageCoreGraphics";
        [self.navigationController pushViewController:demoDrawImageCoreGraphics animated:YES];
        return;
    } else if (indexPath.row == kDemoImageViaOpenGLES) {
        DemoDrawImageOpenGLES *demoDrawImageOpenGLES = [DemoDrawImageOpenGLES new];
        demoDrawImageOpenGLES.view.backgroundColor = [UIColor whiteColor];
        demoDrawImageOpenGLES.navigationItem.title = @"opengl绘制静态图片";
        [self.navigationController pushViewController:demoDrawImageOpenGLES animated:YES];
        return;
    }else if(indexPath.row == kCameraVideoViaOpenGLES)
    {
        OpenCameraGLESViewCtrl* tempView = [OpenCameraGLESViewCtrl new];
        tempView.view.backgroundColor = [UIColor grayColor];
        tempView.navigationItem.title = @"DemoCameraVideoOpenGLES";
        [self.navigationController pushViewController:tempView animated:YES];
        return;
    }
    
    
    self.selectedItem = (NSString *)self.demosOpenGL[indexPath.row];
    [self performSegueWithIdentifier:@"segueFromTableToCell" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ItemViewController *itemVC = (ItemViewController *)segue.destinationViewController;
    itemVC.item = self.selectedItem;
}

@end
