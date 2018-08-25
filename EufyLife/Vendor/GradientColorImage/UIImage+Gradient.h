//
//  UIImage+Gradient.h
//
//  Created by SeanGao on 2018/1/10.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gradient)

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize  要生成的图片的大小
 *  @param colorArr   渐变颜色的数组
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr;

- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors vertical:(BOOL)vertical;

@end
