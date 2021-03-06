//
//  Lottie.h
//  Pods
//
//  Created by brandon_withrow on 1/27/17.
//
//

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#ifndef AnimationFramework_h
#define AnimationFramework_h

//! Project version number for Lottie.
FOUNDATION_EXPORT double LottieVersionNumber;

//! Project version string for Lottie.
FOUNDATION_EXPORT const unsigned char LottieVersionString[];

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import "LOTAnimationTransitionController.h"
#endif

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import "LOTCacheProvider.h"
#endif

#import "LOTAnimationView.h"
#import "LOTAnimationCache.h"
#import "LOTComposition.h"

#endif /* Lottie_h */
