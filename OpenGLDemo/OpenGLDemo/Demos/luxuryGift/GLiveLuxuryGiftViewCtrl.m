
//#if  __has_feature(objc_arc)
//#error This file must be compiled without ARC. Use -fno-objc-arc flag.
//#endif

#import "GLiveLuxuryGiftViewCtrl.h"
#import "GiftPlayView.h"
#import "UIScreenEx.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define ScreedHeight [UIScreen mainScreen].bounds.size.height

@interface GLiveLuxuryGiftViewCtrl (){
    GifitPlayView*                  _mp4PlayView;
    NSMutableArray                  *_files;
    UIButton                        *_playBtn;
    int                             _index;
}
@end
    
@implementation GLiveLuxuryGiftViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageview];
    imageview.frame = self.view.frame;
    imageview.contentMode = UIViewContentModeScaleToFill;

    //by applechang test
    int height = SCREEN_HEIGHT;
    int screenWith = SCREEN_WIDTH;
    int width = height*1.0*9/16;
    int x = 0;
    int y = 0;
    CGRect rc = CGRectMake(x, y, width, height);
    
    _mp4PlayView = [[GifitPlayView alloc]initWithFrame:rc];
    _mp4PlayView.hidden = FALSE;
    [self.view addSubview:_mp4PlayView];
    
    _playBtn = [[UIButton alloc] init];
    _playBtn.frame = CGRectMake(0, ScreedHeight-50, 80, 30);
    [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    [_playBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(onPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.layer.cornerRadius = 10;
    _playBtn.layer.masksToBounds = YES;
    _playBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0] CGColor];
    _playBtn.layer.borderWidth = 0.5;
    [self.view addSubview:_playBtn];
    
    [self.view bringSubviewToFront:_playBtn];
    
    _files =[NSMutableArray arrayWithCapacity:1];
    NSString* path =  [[NSBundle mainBundle] pathForResource:@"aixin.mp4" ofType:nil];
    [_files addObject:path];
    
    
    _index = 0;
}

- (void)onPlayBtnClick
{
    _index ++;
    if(_index >= _files.count)
        _index = 0;
    //NSString *str = [NSString stringWithFormat:@"file://%@",[_files objectAtIndex:_index] ];
    //[_tbplayer setItemByStringPath:str];
    [_mp4PlayView playFile:[_files objectAtIndex:_index]];
}
@end
