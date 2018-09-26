#import "LottieShowViewController.h"
#import "AVFoundation/AVCaptureDevice.h"
#import "LOTAnimationView.h"

typedef NS_ENUM(NSUInteger, CameraOpenResult)
{
    CameraOpenResult_Success,
    CameraOpenResult_CameraForbidden,
    CameraOpenResult_CameraBroken,
    CameraOpenResult_CameraNotExist,
    CameraOpenResult_CameraNotDetermined,
};


@interface LottieShowViewController ()
{
    UILabel* _newMsgLabel;
}
@property (nonatomic, strong) LOTAnimationView* advHatAnimationView;
@end

@implementation LottieShowViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    return self;
}


-(void)viewDidLoad
{
    
    //_speakingAnimationView =
    _newMsgLabel = [[UILabel alloc] init];
    [self.view addSubview:_newMsgLabel];
    _newMsgLabel.hidden = NO;
    _newMsgLabel.font = [UIFont systemFontOfSize:14];
    _newMsgLabel.backgroundColor = [UIColor blackColor];
    _newMsgLabel.text = @"播放Lottie动画";
    _newMsgLabel.textColor = [UIColor grayColor];
    _newMsgLabel.userInteractionEnabled = YES;
    _newMsgLabel.alpha = 0.80;

    _newMsgLabel.frame = CGRectMake(0, 100, 100, 30);

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(onPlayLottieAnimation:)];
    [_newMsgLabel addGestureRecognizer:tapGesture];
}


- (NSString*)getHatAnimationFilePath
{
    uint32_t bigLevel = 5;
    //return [NSString stringWithFormat:@"Animation/OD/advHat/b%u/data.json", bigLevel];
    //return @"Animation/OD/02/02.json";
    return @"Animation/KSong/endPage/endPageAnim.json";
}

- (void)onPlayLottieAnimation:(UITapGestureRecognizer *)sender
{
    [self showHatAnimation:[self getHatAnimationFilePath]];
}

- (void)showHatAnimation:(NSString*)jsonPath
{
    if (!jsonPath) {
        if (!self.advHatAnimationView.hidden) {
            [self.advHatAnimationView stop];
            self.advHatAnimationView.hidden = YES;
        }
    } else {
        if (self.advHatAnimationView != nil) {
            [self.advHatAnimationView stop];
            [self.advHatAnimationView removeFromSuperview];
        }
        
        self.advHatAnimationView = [LOTAnimationView animationNamed:jsonPath];
        self.advHatAnimationView.userInteractionEnabled = false;
        [self.view addSubview:self.advHatAnimationView];
        
        self.advHatAnimationView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.advHatAnimationView.loopAnimation = NO;
        self.advHatAnimationView.hidden = NO;
        
        [self.advHatAnimationView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished == YES) {
                self.advHatAnimationView.hidden = YES;
            }
        }];
    }
}

@end
