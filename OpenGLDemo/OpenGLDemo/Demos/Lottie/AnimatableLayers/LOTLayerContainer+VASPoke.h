//
//  LOTLayerContainer+VASPoke.h
//  Lottie_iOS
//
//  Created by stephen on 2017/8/15.
//  Copyright © 2017年 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOTLayerContainer.h"

@interface LOTLayerContainer (VASPoke)
-(nullable CAAnimationGroup*)genAnimation:(CGFloat)speed
                                fromFrame:(nonnull NSNumber *)fromStartFrame
                                  toFrame:(nonnull NSNumber *)toEndFrame
                                 duration:(NSTimeInterval)duration
                                 isMirror:(BOOL)isMirror;
@end
