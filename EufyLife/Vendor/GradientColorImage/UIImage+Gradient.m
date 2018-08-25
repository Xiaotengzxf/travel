//
//  UIImage+Gradient.m
//  
//  Created by SeanGao on 2018/1/10.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)

- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors {
    return [self createImageWithSize:imageSize gradientColors:colors vertical:NO];
}

- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors vertical:(BOOL)vertical {
    NSArray *percents = [[NSArray alloc] init];
    if (3 == colors.count) {
        percents = @[@(0), @(1.0/3), @(1)];
    } else {
        percents = @[@(0), @(1)];
    }
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start = CGPointMake(0.0, imageSize.height/2);
    CGPoint end = CGPointMake(imageSize.width, imageSize.height/2);
    if (vertical) {
        start = CGPointMake(imageSize.width / 2, 0);
        end = CGPointMake(imageSize.width / 2, imageSize.height);
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
