
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIDevice+Resolution"
#pragma clang diagnostic pop

//
//  UIDevice+Resolution.m
//  QQMSFContact
//
//  Created by rockey on 14-3-4.
//
//

//#import "UIDevice+Resolution.h"
//
//@implementation UIDevice (Resolution)
//
//+ (UIDeviceResolution) currentDeviceResolution {
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        if (CZ_RespondsToSelector([UIScreen mainScreen],  @selector(scale))) {
//            CGSize result = getScreenSize();
//            result = CGSizeMake(result.width * getScreenScale(), result.height * getScreenScale());
//            return (result.height == 960 ? UIDevice_iPhoneHiRes : UIDevice_iPhoneTallerHiRes);
//        } else
//            return UIDevice_iPhoneStandardRes;
//    } else
//        return ((CZ_RespondsToSelector([UIScreen mainScreen],  @selector(scale))) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
//}
//
//@end
