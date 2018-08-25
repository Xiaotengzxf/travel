//
//  ButtonHelper.swift
//  Jouz
//
//  Created by doubll on 2018/5/31.
//  Copyright © 2018年 team. All rights reserved.
//


import UIKit



protocol JColorProtocol {
    func make(alpha:CGFloat, colors:String...) -> [UIColor]
    func color() ->[UIColor]
}

extension JColorProtocol {
    func make(alpha: CGFloat = 1, colors:String...) -> [UIColor] {
        var newColors = [UIColor]()
        for color in colors {
            let color1 = ZColorManager.sharedInstance.colorWithHexString(hex: color)
            newColors.append(color1.withAlphaComponent(alpha))
        }
        return newColors
    }
}

fileprivate enum JButtonColors: JColorProtocol {
    case highlighted, normal, disable
    func color() -> [UIColor] {
        switch self {
        case .highlighted:
            return make(colors: "2B7DA9", "36B9A6")
        case .normal:
            return make(colors: "73B0D1", "73D1C3")
        case .disable:
            return make(alpha: 0.4, colors:"CCCCCC","CCCCCC")
        }
    }
}


fileprivate enum JButtonShadowColor: JColorProtocol {
    func color() -> [UIColor] {
        switch self {
        case .normal:
            return make(colors: "289CFF")
        default:
            return [.clear]
        }
    }
    case normal, none
}

private extension UIButton {
    func makeShadow(color: JButtonShadowColor) {
        setShadowWith(offset: 5, color: color.color().first ?? .lightGray)
    }

    private func setShadowWith(offset: CGFloat, color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 8
    }
}
