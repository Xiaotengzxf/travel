//
//  UIImage+gradientColor.swift
//
//  Created by SeanGao on 2018/1/10.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// - Returns: 返回normal渐变色的图片
    class func gradientNormalColorImage(_ size: CGSize, vertical: Bool = false) -> UIImage {
        return self.gradientColorImage(size, gradientColors: [c_button_normal_left, c_button_normal_right], vertical: vertical)
    }
    
    /// - Returns: 返回press渐变色的图片
    class func gradientPressColorImage(_ size: CGSize) -> UIImage {
        return self.gradientColorImage(size, gradientColors: [c_button_press_left, c_button_press_right])
    }
    
    /// - Returns: 返回白色透明渐变色的图片 透明度从左到右逐渐加深
    class func gradientAlphaWhiteColorImage(_ size: CGSize) -> UIImage {
        return self.gradientColorImage(size, gradientColors: [UIColor(white: 1, alpha: 1), UIColor(white: 1, alpha: 0.5)])
    }
    
    class func gradientBGWhiteColorImage(_ size: CGSize) -> UIImage {
        return self.gradientColorImage(size, gradientColors: [c_background_top, c_background_bottom], vertical: true)
    }

    /// 通过 UIColor 生成渐变色的图片
    /// - Parameter size: 要生成的图片的大小
    /// - Parameter gradientColors: UIColor 数组
    /// - Returns: 返回渐变色图片
    class func gradientColorImage(_ size: CGSize, gradientColors: [Any]!, vertical: Bool = false) -> UIImage {
        let image:UIImage = UIImage().createImage(with: size, gradientColors: gradientColors, vertical: vertical)
        return image
    }
    
    class func getImageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
