//
//  JHUD.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//  https://github.com/jinxiansen
//

#import "JHUD.h"
#import "UIView+JHUD.h"

#define KLastWindow [[UIApplication sharedApplication].windows firstObject]
#define kTAG 88888

#pragma mark -  JHUD Class

@interface JHUD () {
    NSTimer * _timer;
}

@property (nonatomic,strong) JHUDAnimationView  *loadingView;
@property (nonatomic,assign) CGSize indicatorViewSize;

@end

@implementation JHUD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = kTAG;
        [self configureBaseInfo];
        [self configureSubViews];
        NSLog(@"HUD Init");
    }
    return self;
}

-(void)configureBaseInfo {
    self.indicatorViewSize = CGSizeMake(120, 120);
}

-(void)configureSubViews {
    [self addLoadingView];
}

- (void)dealloc {
    NSLog(@"HUD Deinit");
}

#pragma mark - show method 

- (void)showAtView:(UIView *)view {
    if (_timer == nil) {
        if (view != nil) {
            [view addSubview: self];
            [view bringSubviewToFront:self];
        }else{
            [KLastWindow addSubview: self];
            [KLastWindow bringSubviewToFront:self];
        }
        
        [self setupSubViews];
        
    }
}

- (void)hideAtView {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.loadingView stopAnimation];
    [self.loadingView removeFromSuperview];
    
}

+ (void)showAtView:(UIView *)view {
    if ([self showing:view] == NO) {
        JHUD * hud = [[self alloc] initWithFrame: view != nil ? view.bounds : KLastWindow.bounds];
        [hud.loadingView setBackgroundTransparency];
        [hud showAtView: view];
    }
}

+ (void)hideForView:(UIView *)view {
    if (view != nil) {
        JHUD * hud = (JHUD *)[view viewWithTag:kTAG];
        if (hud != nil) {
            [hud hideAtView];
            [hud removeFromSuperview];
            hud = nil;
        }
    }else{
        JHUD * hud = (JHUD *)[KLastWindow viewWithTag:kTAG];
        if (hud != nil) {
            [hud hideAtView];
            [hud removeFromSuperview];
            hud = nil;
        }
    }
}

+ (BOOL)showing:(UIView *)view {
    if (view != nil) {
        JHUD * hud = (JHUD *)[view viewWithTag:kTAG];
        if (hud != nil) {
            return YES;
        }
    } else {
        JHUD * hud = (JHUD *)[KLastWindow viewWithTag:kTAG];
        if (hud != nil && [hud.superview isKindOfClass:[UIWindow class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)setindicatorViewSize:(CGSize)indicatorViewSize {
    _indicatorViewSize = indicatorViewSize;
    [self setNeedsUpdateConstraints];
}

- (void)setupSubViews {
     [self.loadingView showAnimation];
}

#pragma mark  --  Lazy method

- (void)addLoadingView
{
    self.loadingView = [[JHUDAnimationView alloc] init];
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.loadingView];
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        [self addConstraintCenterXToView:self.loadingView centerYToView:self.loadingView];
    }else{
        [self addConstraintCenterXToView:self.loadingView centerYToView:nil];
        [self addConstraintCenterYToView:self.loadingView constant: -32];
    }
    
    [self.loadingView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
   
}

@end

#pragma mark - UIView (MainQueue)

@implementation UIView (MainQueue)

- (void)dispatchMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

@end






