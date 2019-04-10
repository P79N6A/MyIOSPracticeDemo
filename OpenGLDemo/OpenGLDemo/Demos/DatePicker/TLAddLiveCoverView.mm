//
//  TLAddLiveCoverView.m
//  TencentLive
//
//  Created by Carly 黄 on 2019/1/31.
//  Copyright © 2019年 tencent. All rights reserved.
//

#import "TLAddLiveCoverView.h"
#import "PLActionSheetView.h"
#import "PLCropViewController.h"
#import "PLNewPicUploader.h"
#import "PLCommonLoadingView.h"
#import "UIView+BTPosition.h"
#import <AVSDK/AVSDKManager.h>
#import "PLAlertView.h"
#import "PLUtilApp.h"
#import "PLToastView.h"
#import "PLLogReportMgr.h"

#define IMAGE_DEFAULT_SIZE 320.0

typedef NS_ENUM(NSUInteger, CameraOpenResult)
{
    CameraOpenResult_Success,
    CameraOpenResult_CameraForbidden,
    CameraOpenResult_CameraBroken,
    CameraOpenResult_CameraNotExist,
    CameraOpenResult_CameraNotDetermined,
};

@interface TLAddLiveCoverView()<PLActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PLCropViewControllerDelegate, PLNewPicUploaderDelegate>

@property (nonatomic, strong) UIImageView * pickCoverIV;
@property (nonatomic, strong) UILabel * pickCoverLabel;
@property (nonatomic, strong) UIImageView * changeCoverIV;
@property (nonatomic, strong) UIImageView * coverTagIV;

@property (nonatomic, strong) UIImagePickerController * imagePicker;
@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) PLCommonLoadingView * loadingSubView;

@property (nonatomic, strong) PLNewPicUploader * uploader;
@property (nonatomic, weak) id<TLAddLiveCoverDelegate> delegate;

@end

@implementation TLAddLiveCoverView

- (instancetype)init_withDelegate:(id<TLAddLiveCoverDelegate>)delegate type:(TLProgramType)type
{
    self = [super init];
    if (self) {
        self.pWidth = 120;
        self.pHeight = 120;
        self.delegate = delegate;
        
        self.pickCoverIV = [[UIImageView alloc] init];
        [_pickCoverIV setImage:[UIImage loadImage:@"PersonalLive/Program/create/addCover.png"]];
        [self addSubview:_pickCoverIV];
        _pickCoverIV.frame = self.bounds;
        
        self.pickCoverLabel = [[UILabel alloc] init];
        _pickCoverLabel.text = @"添加封面";
        _pickCoverLabel.textColor = RGB2UICOLOR(187, 187, 187);
        _pickCoverLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_pickCoverLabel];
        [_pickCoverLabel sizeToFit];
        _pickCoverLabel.pCenterX = self.pCenterX;
        _pickCoverLabel.pBottom = self.pBottom - 10;
        
        self.changeCoverIV = [[UIImageView alloc] init];
        [_changeCoverIV setImage:[UIImage loadImage:@"PersonalLive/Program/create/changeCover.png"]];
        [self addSubview:_changeCoverIV];
        _changeCoverIV.hidden = YES;
        _changeCoverIV.pWidth = self.pWidth;
        _changeCoverIV.pHeight = self.pWidth / 3.f;
        _changeCoverIV.pCenterX = self.pCenterX;
        _changeCoverIV.pY = self.pHeight - _changeCoverIV.pHeight;
        
        self.coverTagIV = [[UIImageView alloc] init];
        if (type == TLProgramTypeVideo) {
            [_coverTagIV setImage:[UIImage loadImage:@"PersonalLive/Program/covertag_video.png"]];
        } else if (type == TLProgramTypeVoice) {
            [_coverTagIV setImage:[UIImage loadImage:@"PersonalLive/Program/covertag_voice.png"]];
        }
        [self addSubview:_coverTagIV];
        _coverTagIV.hidden = YES;
        _coverTagIV.pWidth = 45;
        _coverTagIV.pHeight = 20;
        _coverTagIV.pX = self.pWidth - _coverTagIV.pWidth - 4;
        _coverTagIV.pY = 4;
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(onAddCoverClick)]) {
        [_delegate onAddCoverClick];
    }
    PLActionSheetView* actionSheetView = [[PLActionSheetView alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"ID_ALERT_CANCEL", @"")
                                                                otherButtonTitles:NSLocalizedString(@"ID_PL_TAKEPHOTO", @""),NSLocalizedString(@"ID_PL_SELECT_PHOTO_FROM_ABULM", @""),nil];
    
    [actionSheetView showActionSheet];
}

- (void)actionSheet:(PLActionSheetView *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePicFromCamera];
    }else if(buttonIndex == 1){
        [self selectPicFromAlbum];
    }
}

-(void)takePicFromCamera
{
    CameraOpenResult result = CameraOpenResult_Success;
    NSString *strOpenCameraFailedMessageTitle;
    NSString *strOpenCameraFailedMessage;
    
    do {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            result = CameraOpenResult_CameraNotExist;
            break;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            result = CameraOpenResult_CameraForbidden;
            break;
        }
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            result = CameraOpenResult_CameraNotDetermined;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) { // 异步
                //completionHandler的回调可以在任意线程队列中，takePicFromCameraInner需要在主线程中执行，需要dispatch到主线程中
                dispatch_async(dispatch_get_main_queue(), ^() {
                    if (granted) {
                        [self takePicFromCameraInner];
                    }
                });
            }];
            break;
        }
        
        if ( ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] &&
            ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            result = CameraOpenResult_CameraBroken;
            break;
        }
        [self takePicFromCameraInner];
    } while (NO);
    
    
    if (result != CameraOpenResult_Success && result != CameraOpenResult_CameraNotDetermined) {
        switch (result) {
            case CameraOpenResult_CameraForbidden:
                strOpenCameraFailedMessageTitle = NSLocalizedString(@"ID_CAMERA_AUTHORITY_REJECT_TITLE", @"");
                strOpenCameraFailedMessage = NSLocalizedString(@"ID_CAMERA_AUTHORITY_REJECT_MESSAGE", @"");
                break;
            case CameraOpenResult_CameraBroken:
            case CameraOpenResult_CameraNotExist:
                strOpenCameraFailedMessageTitle = nil;
                strOpenCameraFailedMessage = NSLocalizedString(@"ID_CAMERA_DETECT_FAILED_MESSAGE", @"");
                break;
            default:
                break;
        }
        PLAlertView *alertView = [[PLAlertView alloc] initWithTitle:strOpenCameraFailedMessageTitle
                                                            message:strOpenCameraFailedMessage
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"ID_CAMERA_MESSAGE_CONFIRM", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)takePicFromCameraInner
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    _imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [[PLUtilApp currentNavigationController] presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)selectPicFromAlbum
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[PLUtilApp currentNavigationController] presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if (image.size.width < IMAGE_DEFAULT_SIZE || image.size.height < IMAGE_DEFAULT_SIZE) {
            [PLToastView showWithToastMode:PLToastViewModeWarning Message:NSLocalizedString(@"ID_PL_START_LIVE_QQHEAD_SO_SMALL", @"")];
            [picker dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        PLCropViewController* viewController = [PLCropViewController new];
        viewController.delegate = self;
        viewController.image = image;
        viewController.cropSize = CGSizeMake(800, 800);
        viewController.isShowAvatarPendant = YES;
        [picker pushViewController:viewController animated:YES];
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        if (editingInfo) {
            UIImage *originalImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
            if (originalImage.size.width < IMAGE_DEFAULT_SIZE || originalImage.size.height < IMAGE_DEFAULT_SIZE) {
                [PLToastView showWithToastMode:PLToastViewModeWarning Message:NSLocalizedString(@"ID_PL_START_LIVE_QQHEAD_SO_SMALL", @"")];
                [picker dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self handleAndUploadImage:image];
    }
}

#pragma mark - PLCropViewControllerDelegate
- (void)cropViewController:(PLCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    
    [_imagePicker performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.2];
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    
    [self handleAndUploadImage:croppedImage];
}

#pragma mark - PLCropViewControllerDelegate
- (void)cropViewControllerDidCancel:(PLCropViewController *)controller{
    [_imagePicker performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.2];
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handleAndUploadImage:(UIImage *)image
{
    CGFloat widthForImage = 640.0;
    CGFloat scale;
    UIImage *scaleImage;
    UIImage *scaledImage;
    if (image.size.width <= image.size.height) {
        scale = widthForImage / image.size.width;
        scaleImage = [UIImage scaleToSize:image size:CGSizeMake(widthForImage, image.size.height*scale)];
    }else if (image.size.width > image.size.height) {
        scale = widthForImage / image.size.height;
        scaleImage = [UIImage scaleToSize:image size:CGSizeMake(image.size.width*scale, widthForImage)];
    }else{
        scaleImage = image;
    }
    scaledImage = [UIImage cropImage:scaleImage inRect:CGRectMake((scaleImage.size.width-widthForImage)/2, (scaleImage.size.height-widthForImage)/2, widthForImage, widthForImage)];
    
    LogFinal(@"ADDCoverView", @"upload cover");
    [self uploadCover:scaledImage];
}

- (void)uploadCover:(UIImage *)image
{
    if (image.size.height < IMAGE_DEFAULT_SIZE || image.size.width < IMAGE_DEFAULT_SIZE)// just show, not reset _bRoomCoverReady.
    {
        self.coverImgStatus = CoverImageStatus_Small;
        _pickCoverIV.image = nil;
        _pickCoverIV.image = image;
        return ;
    }
    
    if (!self.uploader) {
        NSString *uploadUrl = [PLUtilApp getFeedsPicUploadUrl];
        self.uploader = [[PLNewPicUploader alloc] initWithUploadURL:uploadUrl
                                                         withSubCmd:PIC_UPLOAD_SUB_CMD_SHORTVIDEO_COVER
                                                   withExtraInfoDic:nil];
    }
    
    [self.uploader uploadPic:UIImageJPEGRepresentation(image, 0.8) withDelegate:self withParam:nil];
    
    
    [self startAnimatingEx];
}

#pragma mark-PLNewPicUploaderDelegate 上传成功
- (void)onSuccess:(NSData *)imageData withInfo:(NSDictionary *)infoDic withParam:(id)param {
    UIImage* image = [UIImage imageWithData:imageData];
    [self stopAnimatingEx];
    
    self.coverUrl = infoDic[PLNewPicUpload_PicUrl_Key];
    LogFinal(@"ADDCoverView", @"upload cover succ, cover=%@", _coverUrl);
    
    self.coverImgStatus = CoverImageStatus_Ready;
    
    UIImageView* primaryView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:primaryView];
    primaryView.image = _pickCoverIV.image;
    
    UIImageView* secondaryView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:secondaryView];
    secondaryView.image = image;
    // 过渡动画
    [UIView transitionFromView:primaryView
                        toView:secondaryView
                      duration:0.5
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            [primaryView removeFromSuperview];
                            [secondaryView removeFromSuperview];
                            self.pickCoverIV.image = nil;
                            self.pickCoverIV.image = image;
                        }
                    }
     ];
}

#pragma mark-PLNewPicUploaderDelegate
- (void)onError:(NSInteger)errorCode withErrorInfo:(NSError *)errorInfo withParam:(id)param {
    
    LogFinal(@"ADDCoverView", @"upload cover error, errorCode=%d", (int)errorCode);
    [self stopAnimatingEx];
    
    PLAlertView* alert = [[PLAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"ID_PL_PIC_UPLOAD_FAIL_RETRY", @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ID_PL_START_LIVE_QQHEAD_OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [[PLLogReportMgr shareInstance] reportLog];
}

- (void)startAnimatingEx
{
    [self stopAnimatingEx];
    
    self.loadingView = [[UIView alloc] init];
    [_loadingView setBackgroundColor:ARGB2UICOLOR(155, 187, 187, 187)];
    [self addSubview:_loadingView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.loadingView.superview);
    }];
    
    self.loadingSubView = [[PLCommonLoadingView alloc] initWithLoadingText:nil];
    [_loadingView addSubview:_loadingSubView];
    [_loadingSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingSubView.superview.mas_centerX);
        make.centerY.equalTo(self.loadingSubView.superview.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_loadingSubView startAnimating];
}

- (void)stopAnimatingEx
{
    if (_loadingSubView != nil) {
        [_loadingSubView stopAnimating];
        [_loadingSubView removeFromSuperview];
        _loadingSubView = nil;
    }
    
    if (_loadingView != nil) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}

- (void)setCoverImgStatus:(CoverImageStatus)coverImgStatus
{
    if (_coverImgStatus != coverImgStatus) {
        _coverImgStatus = coverImgStatus;
        
        _pickCoverLabel.hidden = _coverImgStatus == CoverImageStatus_Ready;
        _changeCoverIV.hidden = _coverImgStatus != CoverImageStatus_Ready;
        _coverTagIV.hidden = _changeCoverIV.hidden;
    }
}

- (void)setCoverUrl:(NSString *)coverUrl
{
    _coverUrl = coverUrl;
    if (_delegate && [_delegate respondsToSelector:@selector(onCoverChange:)]) {
        [_delegate onCoverChange:coverUrl];
    }
}

@end
