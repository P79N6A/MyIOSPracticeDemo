//
//  BTConstraint.m
//  HuaYang
//
//  Created by britayin on 2017/5/16.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "BTConstraint.h"
#import <UIKit/UIKit.h>

@interface BTConstraint()

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) NSMutableArray *tVfls;
@property (nonatomic, assign) NSLayoutFormatOptions tOpts;
@property (nonatomic, strong) NSMutableDictionary<NSString *,id> *tMetrics;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *tViews;

@end

@implementation BTConstraint

- (instancetype)initWithView:(UIView *)view
{
    if (self = [super init]) {
        self.superView = view;
        self.tMetrics = CZ_NewMutableDictionary();
        self.tViews = CZ_NewMutableDictionary();
    }
    return self;
}

- (BTConstraint * (^)(NSString *vfl))vfl
{
    return ^id(NSString *vfl) {
        if (!_tVfls) {
            _tVfls = CZ_NewMutableArray();
        }
        [_tVfls addObject:vfl];
        return self;
    };
}

- (BTConstraint * (^)(NSLayoutFormatOptions opts))opts
{
    return ^id(NSLayoutFormatOptions opts) {
        self.tOpts = opts;
        return self;
    };
}

- (BTConstraint * (^)(NSDictionary<NSString *,id> * metrics))metrics;
{
    return ^id(NSDictionary<NSString *,id> * metrics) {
        [self.tMetrics addEntriesFromDictionary:metrics];
        return self;
    };
}

- (BTConstraint * (^)(NSDictionary<NSString *, id> * views))views;
{
    return ^id(NSDictionary<NSString *, id> * views) {
        [self.tViews addEntriesFromDictionary:views];
        return self;
    };
}

- (void (^)())commit
{
    return ^void {
        for (NSString * key in self.tViews) {
            UIView *view = self.tViews[key];
            if ([view isDescendantOfView:self.superView] && view!=self.superView) {
                view.translatesAutoresizingMaskIntoConstraints = NO;
            }
        }
        for (NSString *vfl in _tVfls) {
            if (self.tOpts == 0) {
                if ([vfl hasPrefix:@"H:"]) {
                    self.tOpts = self.tOpts| NSLayoutFormatAlignAllCenterY;
                }
                if ([vfl hasPrefix:@"V:"]) {
                    self.tOpts = self.tOpts| NSLayoutFormatAlignAllCenterX;
                }
            }
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:self.tOpts metrics:self.tMetrics views:self.tViews];
            [self.superView addConstraints:constraints];
        }
        self.superView = nil;
    };
    
}

- (void (^)())commitKeepOpt
{
    return ^void {
        for (NSString * key in self.tViews) {
            UIView *view = self.tViews[key];
            if ([view isDescendantOfView:self.superView] && view!=self.superView) {
                view.translatesAutoresizingMaskIntoConstraints = NO;
            }
        }
        for (NSString *vfl in _tVfls) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:self.tOpts metrics:self.tMetrics views:self.tViews];
            [self.superView addConstraints:constraints];
        }
        self.superView = nil;
    };
}

@end
