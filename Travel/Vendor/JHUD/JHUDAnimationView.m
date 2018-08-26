//
//  JHUDAnimationView.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/16.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "JHUDAnimationView.h"
#import "JHUD.h"

#pragma mark -  JHUDLoadingAnimationView Class

@interface JHUDAnimationView () {
    UIView * _contentView;
    UIActivityIndicatorView * _indicatorView;
}

@end

@implementation JHUDAnimationView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setBackgroundTransparency {
    if (_contentView) {
        _contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)showAnimation {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.opacity = 0.6;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"view": _contentView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"view": _contentView}]];
    }

    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView startAnimating];
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_indicatorView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
}

- (void)stopAnimation {
    if (_indicatorView) {
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    
}

@end
