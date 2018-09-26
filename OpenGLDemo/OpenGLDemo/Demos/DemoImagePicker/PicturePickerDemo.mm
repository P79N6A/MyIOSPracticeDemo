#import "PicturePickerDemo.h"
#import "PLActionSheetView.h"
#import "AVFoundation/AVCaptureDevice.h"
#import "PLCropViewController.h"

typedef NS_ENUM(NSUInteger, CameraOpenResult)
{
    CameraOpenResult_Success,
    CameraOpenResult_CameraForbidden,
    CameraOpenResult_CameraBroken,
    CameraOpenResult_CameraNotExist,
    CameraOpenResult_CameraNotDetermined,
};


@interface PicturePickerDemo () <UIImagePickerControllerDelegate, PLActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,PLCropViewControllerDelegate>
{
    UILabel* _newMsgLabel;
    UIImagePickerController *_imagePicker;
}
@end

@implementation PicturePickerDemo

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    return self;
}


-(void)viewDidLoad
{
    _newMsgLabel = [[UILabel alloc] init];
    [self.view addSubview:_newMsgLabel];
    _newMsgLabel.hidden = NO;
    _newMsgLabel.font = [UIFont systemFontOfSize:14];
    _newMsgLabel.backgroundColor = [UIColor blackColor];
    _newMsgLabel.text = @"上传照片";
    _newMsgLabel.textColor = [UIColor grayColor];
    _newMsgLabel.userInteractionEnabled = YES;
    _newMsgLabel.alpha = 0.80;
    
    _newMsgLabel.frame = CGRectMake(0, 100, 100, 30);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(onOpenImagePicker:)];
    [_newMsgLabel addGestureRecognizer:tapGesture];
    
}


- (void)onOpenImagePicker:(UITapGestureRecognizer *)sender
{
    PLActionSheetView* actionSheetView = [[PLActionSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"拍照", @""),NSLocalizedString(@"从手机相册选择", @""),nil];
    
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

-(void)takePicFromCameraInner
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    _imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePicker animated:YES completion:nil];
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
//        PLAlertView *alertView = [[PLAlertView alloc] initWithTitle:strOpenCameraFailedMessageTitle message:strOpenCameraFailedMessage delegate:self cancelButtonTitle:NSLocalizedString(@"ID_CAMERA_MESSAGE_CONFIRM", @"") otherButtonTitles:nil];
//        [alertView show];
    }
}

- (void)selectPicFromAlbum
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
//        if (image.size.width < IMAGE_DEFAULT_SIZE || image.size.height < IMAGE_DEFAULT_SIZE) {
//            [PLToastView showWithToastMode:PLToastViewModeWarning Message:NSLocalizedString(@"ID_PL_START_LIVE_QQHEAD_SO_SMALL", @"")];
//            [picker dismissViewControllerAnimated:YES completion:nil];
//            return;
//        }

        PLCropViewController* viewController = [PLCropViewController new];
        viewController.delegate = self;
        viewController.image = image;
        viewController.cropSize = CGSizeMake(800, 800);
        viewController.isShowAvatarPendant = YES;
        [picker pushViewController:viewController animated:YES];
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        [picker dismissViewControllerAnimated:YES completion:nil];
//        [self handleAndUploadImage:image];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
@end
