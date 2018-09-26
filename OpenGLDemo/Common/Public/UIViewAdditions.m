
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "UIViewAdditions"
#pragma clang diagnostic pop

//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.CZ_F_OriginX;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.CZ_F_OriginY;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.CZ_F_OriginX + self.CZ_F_SizeW;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.CZ_F_OriginY + self.CZ_F_SizeH;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.CZ_F_SizeW;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    CZ_SetFrame(self, frame);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.CZ_F_SizeH;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    CZ_SetFrame(self, frame);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		CZ_UIViewRemoveSubView( child );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIView *)findSubview:(NSString *)name
{
    return [self findSubview:name resursion:NO];
}

- (UIView *)findSubview:(NSString *)name resursion:(BOOL)resursion
{
    Class class = NSClassFromString(name);
	for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
	}
	
	if (resursion) {
		for (UIView *subview in self.subviews) {
			subview = [subview findSubview:name resursion:resursion];
			if (subview) {
				return subview;
			}
		}
	}
	
	return nil;
}

- (UIView*)findSuperview:(NSString*)name
{
    UIView* superview = self.superview;
    while (superview != nil) {
        if ([[[superview class] description] isEqualToString:name] || [superview isKindOfClass:NSClassFromString(name)]) {
            return superview;
        }
        superview = superview.superview;
    }
    
    return nil;
}

- (UIView *)findTopSuperview
{
    UIView* superview = self.superview;
    while (superview != nil) {
        if (superview.superview == nil) {
            return superview;
        }
        
        superview = superview.superview;
    }
    
    return nil;
}

//Find the view we want in camera structure.
-(UIView *)findView:(UIView *)aView withName:(NSString *)name
{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if (CZ_StringEqualToString(name, desc))
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

// get the current view screen shot
- (UIImage*)capture
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (UIImage*)captureWithClearBackgroundWith2x
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO , 2);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)resignAllFirstResponder
{
    [self resignFirstResponder];
    
    for (UIView* view in self.subviews) {
        [view resignAllFirstResponder];
    }
}

- (void)layerSmooth
{
    self.layer.borderWidth = 3.0;
    self.layer.borderColor = GlobalClearColor.CGColor;
    self.layer.shouldRasterize = YES;
    
    for (UIView* subView in self.subviews) {
        [subView layerSmooth];
    }
}

@end
