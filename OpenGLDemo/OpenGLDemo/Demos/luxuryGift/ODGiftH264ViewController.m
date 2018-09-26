#import "ODGiftH264ViewController.h"
#import "GiftPlayView.h"
#import "LOTAnimationView.h"
#import <AVFoundation/AVFoundation.h>
//#import "UIDevice+Util.h"
//#import "ODConstants.h"
#import "UIScreenEx.h"
//#import "ODNetResFileLoader.h"
//#import "NSStringEX.h"
//#import "ODFileUtil.h"
//#import "NSDataEX.h"
//#import "MiniZipArchive.h"
//#import "ODUrlImageView.h"
//#import "UIColor+OD.h"
//#import "ODCppUtil.h"
//
//#import "ODUserMgr.h"
//#import "ODUser.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wobjc-method-access"


@interface ODGiftH264HitThroughView : UIView
@end

@implementation ODGiftH264HitThroughView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

-(void)dealloc
{
    [super dealloc];
}

@end

@interface ODGiftH264ViewController () <IPLGiftPlayListener>
{
    AVPlayerItemVideoOutput     *_videoOutput;
    AVPlayer                    *_player;
    AVPlayerItem                *_playerItem;
    CADisplayLink               *_displayLink;
    BOOL                        _sendSize;
}

@property(nonatomic, strong) GifitPlayView *playView;               //礼物视频渲染视图
@property(nonatomic, strong) LOTAnimationView *lotAniView;          //lottie动画播放控件
@property(nonatomic, strong) NSURL *url;                            //当前播放动效url
@property(nonatomic, strong) ODLOTImageReplaceMgr *imgReplaceMgr;   //图片资源替换管理器
@property(nonatomic, copy)   NSString *replaceJson;                 //自定义的资源替换配置

@end

@implementation ODGiftH264ViewController
{
    BOOL _isVideoPlaying;
    BOOL _isLottiePlaying;
}

+ (ODGiftH264ViewController*)sharedInstance
{
    static dispatch_once_t token;
    static ODGiftH264ViewController * __OD_GIFT_H264_instance;
    dispatch_once( &token, ^{
        __OD_GIFT_H264_instance = [ODGiftH264ViewController new];
    });
    return __OD_GIFT_H264_instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.imgReplaceMgr = [ODLOTImageReplaceMgr new];
     }
    return self;
}

- (void)dealloc{
    _playView.delegate  = nil;
    [_playView release];
    _playView = nil;
    

    [_lotAniView release];
    _lotAniView = nil;
    
    [self.imgReplaceMgr clear];
    if (self.imgReplaceMgr == LOTCacheProvider.imageCache) {
        [LOTCacheProvider setImageCache:nil];
    }
    self.imgReplaceMgr = nil;
    self.url = nil;
    self.replaceJson = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[[ODGiftH264HitThroughView alloc] initWithFrame:self.view.frame] autorelease];
    self.view.backgroundColor = [UIColor clearColor];
    
    //by applechang test
    int height = SCREEN_HEIGHT;
    int width = height*1.0*9/16;
    int x = 0;
    int y = 0;
    CGRect rc = CGRectMake(x, y, width, height);
    
    self.playView = [[[GifitPlayView alloc] initWithFrame:rc] autorelease];
    self.playView.backgroundColor = [UIColor clearColor];
    self.playView.delegate = self;
    self.playView.hidden = YES;
    [self.view addSubview:_playView];
}

- (BOOL)isSupportHideNavigateBar{
    return YES;
}

- (void)play:(NSURL *)url {
    [self play:url customJson:@""];
}

- (void)play:(NSURL *)url customJson:(NSString *)customJson
{
    if (!url) {
//        if ([self.h264Delegate respondsToSelector:@selector(onODH264GiftError:)]) {
//            [self.h264Delegate onODH264GiftError:GLIVEMP4_ERROR_RES_ERROR];
//        }
        return;
    }
    
    if ([url isFileURL]) {
        [self stopPlay];
        /*
        ODUser *user = [[ODUserMgr shareInstance] queryUserByUid:[ODUserMgr shareInstance].selfUid create:YES];
        NSString *avatarUrl = @"http://0000000";
        if (user.avatar && [ODNetResFileUtil isFileDownloaded_url:user.avatar]) {
            avatarUrl = [NSURL fileURLWithPath:[ODNetResFileUtil filePathForUrl:user.avatar]].absoluteString;
        }
        
        customJson = [NSString stringWithFormat:@"{\"text_replace\": [{\"key\": \"REPLACE_TAG_AVATAR\",\"value\": \"%@\"},{\"key\": \"REPLACE_TAG_USER_NAME\",\"value\": \"%@\"}]}", avatarUrl, (user.name?user.name:@"无昵称")];
        */
        self.url = url;
        self.replaceJson = customJson;
        
        //文件
        if ([self unZipPacket]) {
            [self startPlay];
        }else{
//            if ([self.h264Delegate respondsToSelector:@selector(onODH264GiftError:)]) {
//                [self.h264Delegate onODH264GiftError:GLIVEMP4_ERROR_RES_ERROR];
//            }
        }
        
    }else if ([url.scheme.uppercaseString isEqualToString:@"HTTP"] || [url.scheme.uppercaseString isEqualToString:@"HTTPS"]) {
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        if (url) userInfo[@"url"] = url;
//        if (customJson) userInfo[@"customJson"] = customJson;
//        [[ODNetResFileLoader sharedLoader] loadNetResFile:url.absoluteString onResult:[ODBlock selector:@selector(onLoadNetResFileResult:) target:self userInfo:userInfo]];
    }else{
//        if ([self.h264Delegate respondsToSelector:@selector(onODH264GiftError:)]) {
//            [self.h264Delegate onODH264GiftError:GLIVEMP4_ERROR_RES_ERROR];
//        }
    }
    
}

//- (void)onLoadNetResFileResult:(ODBlockResult *)result
//{
//    NSURL *url = result.userInfo[@"url"];
//    NSString *customJson = result.userInfo[@"customJson"];
//    if (!result.error) {
//        //加载成功
//        NSString *filePath = result.params[url.absoluteString];
//        [self play:[NSURL fileURLWithPath:filePath] customJson:customJson];
//    }else{
//        //加载失败
//        if ([self.h264Delegate respondsToSelector:@selector(onODH264GiftError:)]) {
//            [self.h264Delegate onODH264GiftError:GLIVEMP4_ERROR_DOWNLOAD_ERROR];
//        }
//    }
//}

- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    else
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)string2json:(NSString *)str
{
    if (!str) {
        return nil;
    }
    NSDictionary *jsonObj = nil;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return jsonObj;
}

- (NSString *)json2string:(id)json
{
    if (!json) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (id)file2json:(NSString *)filePath
{
    if (!filePath) {
        return nil;
    }
    NSDictionary *jsonObj = nil;
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    if (jsonData) {
        jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return jsonObj;
}

- (NSString *)getUnZipPath
{
//    NSString* urlMd5 = [self.url.path.lastPathComponent dataUsingEncoding:NSUTF8StringEncoding].getMd5HashString;
//    NSString *unZipPath = [[NSStringDocPath() stringByAppendingPathComponent:@"GLiveH264Gift"] stringByAppendingPathComponent:urlMd5];
//    return unZipPath;
    NSString* unZipPath = @"test";
    return unZipPath;
}

- (NSString *)getMp4FilePath
{
    return [[self getUnZipPath] stringByAppendingPathComponent:@"0000V.mp4"];
}

- (NSString *)getConfigFilePath
{
    return [[self getUnZipPath] stringByAppendingPathComponent:@"config.json"];
}

- (NSString *)getDataFilePath
{
    return [[self getUnZipPath] stringByAppendingPathComponent:@"data.json"];
}

- (NSString *)getImagesPath
{
    return [[self getUnZipPath] stringByAppendingPathComponent:@"images"];
}

- (NSString *)getImagePath:(NSString *)fileName
{
    return [[self getImagesPath] stringByAppendingPathComponent:fileName];
}

// zip解压
-(BOOL)unZipPacket
{
    if ([self checkUnZipResult]) {
        //已解压成功
        return YES;
    }
    
    NSString *zipFilePath = self.url.path;
    NSString *unZipPath = [self getUnZipPath];
    
    //解压
//    if(![ODFileUtil unzipFile:zipFilePath toPath:unZipPath]){
//        return NO;
//    }
    
    if (![self checkUnZipResult]) {
        //已解压成功
        return NO;
    }
    
    return YES;
}

// 检查解压是否完整
-(BOOL)checkUnZipResult
{
    NSString *unZipPath = [self getUnZipPath];
    
//    if (!CZ_IsFileExistFunc(unZipPath)) {
//        return NO;
//    }
    
//    if (!CZ_IsFileExistFunc([self getMp4FilePath]) && !CZ_IsFileExistFunc([self getDataFilePath])) {
//        return NO;//既没有视频也没有lottie动画
//    }
    
    return YES;
}
 
- (void)startPlay
{
    NSString *videoFile = [self getMp4FilePath];
    
//    if (!CZ_IsFileExistFunc([self getMp4FilePath])) {
//    }else{
//        self.playView.hidden = NO;
//        _isVideoPlaying = YES;
//        [self.playView playFile:[NSURL fileURLWithPath:videoFile]];
//    }
    
    [self starLottieAnimationInternal];
    self.view.hidden = NO;
}

//暂时不要删除，后面applechang 来处理
-(void)PlayTestFile
{
    //applechang test
    NSString* testFilepath = [[NSBundle mainBundle] pathForResource:@"huojian_zuoyou.mp4" ofType:nil];
    NSString* str = [NSString stringWithFormat:@"file://%@",testFilepath ];
    [self.playView playFile:[NSURL URLWithString:str]];
    self.playView.hidden = NO;
}

- (void)stopPlay
{
    self.url = nil;
    self.replaceJson = nil;
    [self.imgReplaceMgr clear];
    
    //GLiveLogFinal("ODGiftH264ViewController.cancelCurrentGiftAnimation");
    if ([self.lotAniView isAnimationPlaying]) {
        [self.lotAniView pause];
        [self.lotAniView stop];
        [self.lotAniView removeFromSuperview];
        self.lotAniView = nil;
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(starLottieAnimationInternal) object:nil];
    }
    
    if (self.playView.hidden == NO) {
        [self.playView stopPlay];
        self.playView.hidden = YES;
    }
    
    _isVideoPlaying = NO;
    _isLottiePlaying = NO;
    
    self.view.hidden = YES;
}

- (void)starLottieAnimationInternal
{
    //GLiveLogFinal("ODGiftH264ViewController.starLottieAnimationInternal");
    if (self.lotAniView) {
        [self.lotAniView stop];
        [self.lotAniView removeFromSuperview];
    }
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:[self getDataFilePath]];
    if (!jsonData) {
        return;
    }
    NSDictionary *jsonObj = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] : nil;
    if (!jsonObj) {
        return;
    }
    NSMutableDictionary *lottieJson = [NSMutableDictionary dictionaryWithDictionary:jsonObj];
    if (!lottieJson) {
        return;
    }
    NSString *imagesPath = [self getImagesPath];
    
    //设置替换资源
    //[self applyReplace];
    
    NSBundle *bundle = [NSBundle bundleWithPath:imagesPath];

    [LOTCacheProvider setImageCache:self.imgReplaceMgr];
    
    LOTComposition *laScene = [[LOTComposition alloc] initWithJSON:lottieJson withAssetBundle:bundle];
    laScene.rootDirectory = [imagesPath stringByDeletingLastPathComponent];
    
    self.lotAniView = [[LOTAnimationView alloc] initWithModel:laScene inBundle:bundle];
    self.lotAniView.contentMode = UIViewContentModeScaleAspectFill;
    self.lotAniView.SDPType = @"7";
    CGRect rcLotAniView = self.view.bounds;
    
//    if (([[UIDevice currentDevice] platformType] == UIDeviceXiPhone))
//    {
//        //暂时这样处理
//        UIEdgeInsets inset = self.view.safeAreaInsets;
//        inset.top += 30;
//        rcLotAniView = UIEdgeInsetsInsetRect(rcLotAniView, inset);
//    }
    [self.lotAniView setFrame:rcLotAniView];
    [self.view addSubview:self.lotAniView];
    
    NSDictionary *defaultConfigJson = [self file2json:[self getConfigFilePath]];
    NSString *videoOnTop = defaultConfigJson[@"videoOnTop"];
    if (videoOnTop && [videoOnTop.lowercaseString isEqualToString:@"true"] && self.playView) {
        [self.view bringSubviewToFront:self.playView];
    }
    
    //设置添加的控件
    NSDictionary *replaceLayers = [self getAppendViews:lottieJson];
    NSEnumerator *em = replaceLayers.keyEnumerator;
    NSString *layerName = nil;
    while (layerName = [em nextObject]) {
        [self.lotAniView addSubview:replaceLayers[layerName] toLayerNamed:layerName applyTransform:YES];
    }
    
    _isLottiePlaying = YES;
    [self playWithCompletion];
}

- (void)playWithCompletion
{
    [self.lotAniView playWithCompletion:^(BOOL animationFinished) {
        [self onPlayWithCompletion:animationFinished];
    }];
}

- (void)onPlayWithCompletion:(BOOL)animationFinished {
    //GLiveLogFinal("ODGiftH264ViewController.playWithCompletion lot animation completion: %d",animationFinished);
    if (animationFinished) {
        [self.lotAniView removeFromSuperview];
        self.lotAniView = nil;
    }
    _isLottiePlaying = NO;
    [self checkComplete];
    [self.imgReplaceMgr clear];
}

- (NSDictionary *)getAppendViews:(NSDictionary *)lottieJson
{
    NSMutableDictionary *replaceLayers = [NSMutableDictionary dictionary];
    
    NSDictionary *json = lottieJson;
    NSArray *assets = json[@"assets"];
    for (NSUInteger i = 0; i < assets.count; i++) {
        NSDictionary *asset = assets[i];
        NSString *assetImageName = asset[@"p"];
        UIView *customView = [self onAddViewForResource:assetImageName];
        if (customView) {
            NSString *assetId = asset[@"id"];
            NSArray *layers = json[@"layers"];
            for (NSUInteger j = 0; j < layers.count; j++) {
                NSDictionary *layer = layers[j];
                NSString *refId = layer[@"refId"];
                if ([assetId isEqualToString:refId]) {
                    NSString *layerName = layer[@"nm"];
                    NSString *cl = layer[@"cl"];
                    if ([cl.lowercaseString isEqualToString:@"png"] || [cl.lowercaseString isEqualToString:@"jpg"] || [cl.lowercaseString isEqualToString:@"jpeg"]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:[[self getImagesPath] stringByAppendingPathComponent:assetImageName]];
                        customView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        replaceLayers[layerName] = customView;
                    }
                    
                }
            }
        }
    }
    
    return replaceLayers;
}

//添加自定义的控件
- (UIView *)onAddViewForResource:(NSString *)resourceName
{
    /*
    if ([resourceName isEqualToString:@"avatar.png"]) {
        ODUrlImageView *imageView = [[ODUrlImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        [imageView loadUrl:@"http://img3.imgtn.bdimg.com/it/u=1121475478,2545730346&fm=214&gp=0.jpg"];
        return imageView;
    }else if ([resourceName isEqualToString:@"text.png"]) {
        UILabel *lable = [UILabel new];
        lable.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        lable.text = @"测试文本";
        lable.textColor = UIColor.redColor;
        return lable;
    }
     */
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark ODGiftPlayListener delegate
- (void)onVideoSize:(int)width andHeight:(int)height
{
    //todo something you want
}

- (void)onStart
{
    //GLiveLogFinal("ODGiftH264ViewController.onStart");
}

- (void)onEnd
{
    //GLiveLogFinal("ODGiftH264ViewController.enEnd");
    _playView.hidden = YES;
    _isVideoPlaying = NO;
    
    [self checkComplete];
}

- (void)checkComplete
{
    if (!_isLottiePlaying && !_isLottiePlaying) {
        //GLiveLogFinal("ODGiftH264ViewController.finalEnd by video");
        self.view.hidden = YES;
//        if (self.h264Delegate && [self.h264Delegate respondsToSelector:@selector(onODH264GiftEnd)]) {
//            [self.h264Delegate onODH264GiftEnd];
//        }
    }
}

//某个时间戳的回调
- (void)onPlayAtTime:(uint64_t)presentationTimeUs
{
}

- (void)onError:(int)errorCode
{
    //GLiveLogFinal("ODGiftH264ViewController palyFail %d",errorCode);
    [self stopPlay];
    
    _isVideoPlaying = NO;
    _playView.hidden = YES;
    //applechang 是否需要数据上报
    
//    if ([self.h264Delegate respondsToSelector:@selector(onODH264GiftError:)]) {
//        [self.h264Delegate onODH264GiftError:GLIVEMP4_ERROR_PLAY_ERROR];
//    }
}

@end

@interface ODLOTImageReplaceMgr () 

@property (nonatomic, strong) NSMutableDictionary *replaceImagePath;    //替换文件路径
@property (nonatomic, strong) NSMutableDictionary *replaceImage;        //替换为UIImage

@end

@implementation ODLOTImageReplaceMgr
#pragma mark - LOTImageCache
- (UIImage *)imageForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    
    NSString *imagePath = self.replaceImagePath[key];
    if (imagePath) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    
    UIImage *image = self.replaceImage[key];
    return image;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    
}

- (void)replaceImagePath:(NSString *)path byImagePath:(NSString *)replacePath
{
    if (!path || !replacePath) {
        return;
    }
    if (!self.replaceImagePath) {
        self.replaceImagePath = [NSMutableDictionary dictionary];
    }
    self.replaceImagePath[path] = replacePath;
}

- (void)replaceImagePath:(NSString *)path byImage:(UIImage *)image
{
    if (!path || !image) {
        return;
    }
    if (!self.replaceImage) {
        self.replaceImage = [NSMutableDictionary dictionary];
    }
    self.replaceImage[path] = image;
}

- (void)clear
{
    [self.replaceImagePath removeAllObjects];
    [self.replaceImage removeAllObjects];
}

- (void)removePathReplace:(NSString *)path
{
    [self.replaceImagePath removeObjectForKey:path];
    [self.replaceImage removeObjectForKey:path];
}

@end

#pragma clang diagnostic pop
