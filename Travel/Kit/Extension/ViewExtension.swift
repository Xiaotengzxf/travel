//
//  ViewExtension.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

extension UIView {
    func insertGradientLayer(size: CGSize, isHaveShadow: Bool = false, cornerRadius: CGFloat = 0, direction: GradientColorDeriction = .leftToRight, colors: [UIColor] = [c_button_normal_left, c_button_normal_right])  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map{$0.cgColor}
        var x : CGFloat = 0, y : CGFloat = 0, x1 : CGFloat = 0, y1 : CGFloat = 0
        switch direction {
        case .upToDown:
            x = 0.5; y = 0; x1 = 0.5; y1 = 1
        case .leftToRight:
            x = 0; y = 0.5; x1 = 1; y1 = 0.5
        case .upToDownAndLeftToRight:
            x = 0; y = 0; x1 = 1; y1 = 1
        default:
            x = 0; y = 0.5; x1 = 1; y1 = 0.5
        }
        gradientLayer.startPoint = CGPoint(x: x, y: y)
        gradientLayer.endPoint = CGPoint(x: x1, y: y1)
        if cornerRadius > 0 {
            gradientLayer.cornerRadius = cornerRadius
        }
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if isHaveShadow {
            gradientLayer.shadowColor = c_button_shadow.cgColor
            gradientLayer.shadowOffset = CGSize(width: 0, height: 6 * scale)
            gradientLayer.shadowOpacity = 0.5
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func getGradientLayer() -> CAGradientLayer? {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer is CAGradientLayer {
                    return layer as? CAGradientLayer
                }
            }
        }
        return nil
    }
    
    func setBlurBackground(size: CGSize, cornerRadius: CGFloat, addShadow: Bool = true) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        addSubview(visualEffectView)
        backgroundColor = c1.withAlphaComponent(0.7)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let effectView = UIVisualEffectView(effect: vibrancyEffect)
        effectView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        //effectView.contentView.addSubview(self)
        visualEffectView.contentView.addSubview(effectView)
        visualEffectView.alpha = 0.85
        
    }
    
}

enum GradientColorDeriction: Int {
    case upToDown
    case downToUp
    case leftToRight
    case rightToLeft
    case upToDownAndLeftToRight
    case downToUpAndRightToLeft
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
