//
//  UIColor+valueRGB.swift
//  SGCirleProgress
//
//  Created by SeanGao on 2018/1/9.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((valueRGB & 0x0000FF)) / 255.0,
            alpha: alpha
        )
    }
}

