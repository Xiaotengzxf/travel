//
//  JHUD.h
//  JHUDDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//  https://github.com/jinxiansen
//

#import <UIKit/UIKit.h>
#import "JHUDAnimationView.h"

@interface JHUD : UIView

+ (void)showAtView:(UIView *)view;
+ (void)hideForView:(UIView *)view;

@end

@interface UIView (MainQueue)

- (void)dispatchMainQueue:(dispatch_block_t)block;

@end







