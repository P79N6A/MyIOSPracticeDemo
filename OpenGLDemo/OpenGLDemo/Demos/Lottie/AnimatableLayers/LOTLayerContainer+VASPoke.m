//
//  LOTLayerContainer+VASPoke.m
//  Lottie_iOS
//
//  Created by stephen on 2017/8/15.
//  Copyright © 2017年 Airbnb. All rights reserved.
//

#import "LOTLayerContainer+VASPoke.h"
#import "LOTNumberInterpolator.h"
#import "LOTTransformInterpolator.h"

@implementation LOTLayerContainer (VASPoke)

- (CATransform3D)transform:(LOTTransformInterpolator*)transformInterpolator
                  forFrame:(NSNumber *)frame
                  isMirror:(BOOL)isMirror {
    CATransform3D baseXform = CATransform3DIdentity;
    if (transformInterpolator.inputNode) {
        baseXform = [transformInterpolator.inputNode transformForFrame:frame];
    }
    CGPoint position = CGPointZero;
    if (transformInterpolator.positionInterpolator) {
        position = [transformInterpolator.positionInterpolator pointValueForFrame:frame];
    }
    if (transformInterpolator.positionXInterpolator &&
        transformInterpolator.positionYInterpolator) {
        position.x = [transformInterpolator.positionXInterpolator floatValueForFrame:frame];
        position.y = [transformInterpolator.positionYInterpolator floatValueForFrame:frame];
    }
    CGPoint anchor = [transformInterpolator.anchorInterpolator pointValueForFrame:frame];
    if(isMirror) {
        position.x = -position.x;
        anchor.x = -anchor.x;
    }
    CGSize scale = [transformInterpolator.scaleInterpolator sizeValueForFrame:frame];
    CGFloat rotation = [transformInterpolator.rotationInterpolator floatValueForFrame:frame];
    CATransform3D translateXform = CATransform3DTranslate(baseXform, position.x, position.y, 0);
    CATransform3D rotateXform = CATransform3DRotate(translateXform, rotation, 0, 0, 1);
    CATransform3D scaleXform = CATransform3DScale(rotateXform, scale.width, scale.height, 1);
    CATransform3D anchorXform = CATransform3DTranslate(scaleXform, -1 * anchor.x, -1 * anchor.y, 0);
    return anchorXform;
}

-(nullable CAAnimationGroup*)genAnimation:(CGFloat)speed
                                fromFrame:(nonnull NSNumber *)fromStartFrame
                                  toFrame:(nonnull NSNumber *)toEndFrame
                                 duration:(NSTimeInterval)duration
                                 isMirror:(BOOL)isMirror
{
    LOTNumberInterpolator *opacityInterpolator = [self valueForKey:@"_opacityInterpolator"];
    LOTTransformInterpolator *transformInterpolator = [self valueForKey:@"_transformInterpolator"];
    
    NSMutableArray *valuesOpacity = [NSMutableArray new];
    NSMutableArray *valuesTransform = [NSMutableArray new];
    for(int i=fromStartFrame.intValue; i<=toEndFrame.intValue; i++) {
        if (opacityInterpolator) {
            CGFloat opacity = [opacityInterpolator floatValueForFrame:@(i)];
            [valuesOpacity addObject:@(opacity)];
        }
        if (transformInterpolator) {
            CATransform3D transform = [self transform:transformInterpolator forFrame:@(i) isMirror:isMirror];
            //CATransform3D transform = [transformInterpolator transformForFrame:@(i)];
            [valuesTransform addObject:[NSValue valueWithCATransform3D:transform]];
        }
    }
    
    NSMutableArray<CAAnimation *> *animations = [NSMutableArray<CAAnimation *> new];
    if(valuesOpacity.count > 0) {
        CAKeyframeAnimation *animOpacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        animOpacity.speed = speed;
        animOpacity.duration = duration;
        animOpacity.fillMode = kCAFillModeBoth;
        animOpacity.repeatCount = 1;
        animOpacity.values = valuesOpacity;
        [animations addObject:animOpacity];
    }
    
    if(valuesTransform.count > 0 ) {
        CAKeyframeAnimation *animTransform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animTransform.speed = speed;
        animTransform.duration = duration;
        animTransform.fillMode = kCAFillModeBoth;
        animTransform.repeatCount = 1;
        animTransform.values = valuesTransform;
        [animations addObject:animTransform];
    }
    
    if(animations.count > 0) {
        CAAnimationGroup *animation = [CAAnimationGroup new];
        animation.animations = animations;
        animation.duration = duration;
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = NO;
        return animation;
    }
    return nil;
}

@end
