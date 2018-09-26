//
//  ViewController.m
//  giftDemo
//
//  Created by 魏亮 on 2017/3/1.
//  Copyright © 2017年 魏亮. All rights reserved.
//

#import "ViewController.h"
//#import "GLView/GLView.h"
//#import "player.h"
#import "GiftPlayView.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define ScreedHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<IPLGiftPlayListener>
{
    NSMutableArray                  *_files;
    UIButton                        *_playBtn;
    //GLView                          *_glview;
    //player                          *_player;
    GifitPlayView                   *_playView;
    int                             _index;
}

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageview];
    imageview.frame = self.view.frame;
    imageview.contentMode = UIViewContentModeScaleToFill;
    

    _playBtn = [[UIButton alloc] init];
    _playBtn.frame = CGRectMake(0, ScreedHeight-50, 80, 30);
    [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.layer.cornerRadius = 10;
    _playBtn.layer.masksToBounds = YES;
    _playBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] CGColor];
    _playBtn.layer.borderWidth = 0.5;
    [self.view addSubview:_playBtn];
    _playView = [[GifitPlayView alloc]initWithFrame:self.view.frame];

    [self.view addSubview:_playView];
    _playView.hidden = YES;
    _playView.backgroundColor = [UIColor clearColor];
    _playView.delegate = self;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSFileManager* fm=[NSFileManager defaultManager];
//    NSArray *files = [fm subpathsAtPath: docDir ];
//    if ([files count] == 0) {
//        return;
//    }
//    _files = [NSMutableArray arrayWithCapacity:[files count]];
    _files =[NSMutableArray arrayWithCapacity:1];
    
    NSString* path =  [[NSBundle mainBundle] pathForResource:@"huojian_zuoyou.mp4" ofType:nil];
    [_files addObject:path];
    
//    for(NSString * file in files)
//    {
//
//        NSString * path = [NSString stringWithFormat:@"%s/%s",[docDir UTF8String],
//                           [file UTF8String]];
//        [_files addObject:path];
//    }
   
    _index = -1;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)play
{
    _index ++;
    if(_index >= _files.count)
        _index = 0;
    //NSString *str = [NSString stringWithFormat:@"file://%@",[_files objectAtIndex:_index] ];
    //[_tbplayer setItemByStringPath:str];
    [_playView playFile:[_files objectAtIndex:_index]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onVideoSize:(int)width andHeight:(int)height
{
    NSLog(@"on VideoSize width = %d height = %d",width,height);

}
- (void)onStart
{
    NSLog(@"playstarted!");

}
- (void)enEnd
{
    
    NSLog(@"playend!");

}
- (void)onPlayAtTime:(uint64_t)presentationTimeUs
{
    NSLog(@"playtime = %llu",presentationTimeUs);
}

- (void)onError:(int)errorCode
{
 NSLog(@"playerror!");
}


@end
