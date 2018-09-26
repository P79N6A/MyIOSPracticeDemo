//
//  LOTAnimationViewVasPoke.m
//  TlibDy
//
//  Created by stephen on 2017/8/15.
//  Copyright © 2017年 com.tencent.macaw. All rights reserved.
//

#import "LOTAnimationViewVasPoke.h"
#import "LOTCompositionContainer.h"
#import "LOTLayerContainer+VASPoke.h"

@implementation LOTAnimationViewVasPoke

+(CAAnimationGroup*)animationForWindow:(LOTAnimationView*)lotView isMirror:(BOOL)isMirror
{
    LOTCompositionContainer *compContainer = [lotView valueForKey:@"_compContainer"];
    if(!compContainer)
        return nil;
    if(compContainer.wrapperLayer.sublayers.count <= 0)
        return nil;
    NSTimeInterval duration = ((lotView.sceneModel.endFrame.floatValue - lotView.sceneModel.startFrame.floatValue) / lotView.sceneModel.framerate.floatValue);
    LOTLayerContainer *child = (LOTLayerContainer*)[compContainer.wrapperLayer.sublayers lastObject];
    return [child genAnimation:lotView.animationSpeed
                     fromFrame:lotView.sceneModel.startFrame
                       toFrame:lotView.sceneModel.endFrame
                      duration:duration
                      isMirror:isMirror];
}

@end
