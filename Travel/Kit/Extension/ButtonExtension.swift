//
//  ButtonExtension.swift
//  Jouz
//
//  Created by ANKER on 2018/1/15.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension UIButton {
    private func setShadow(cornerRadius: CGFloat) {
        if !isHaveShadowView() {
            let shadowView = UIView()
            shadowView.tag = Int.max - 1
            shadowView.layer.cornerRadius = cornerRadius
            shadowView.layer.shadowOpacity = 0.2
            shadowView.layer.shadowColor = c_button_shadow.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 6)
            shadowView.layer.backgroundColor = UIColor.white.cgColor
            shadowView.translatesAutoresizingMaskIntoConstraints = false
            self.superview?.insertSubview(shadowView, belowSubview: self)
            self.superview?.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            self.superview?.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
            self.superview?.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
            self.superview?.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
        }
    }
    
    private func isHaveShadowView() -> Bool {
        if let sView = self.superview {
            if sView.tag == Int.max - 1 {
                return true
            }
        }
        return false
    }
    
    func setBackground(size: CGSize, cornerRadius: CGFloat, addShadow: Bool = true) {
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
        setBackgroundImage(UIImage.gradientNormalColorImage(size), for: .normal)
        setBackgroundImage(UIImage.gradientPressColorImage(size), for: .highlighted)
        if addShadow {
            setShadow(cornerRadius: cornerRadius)
        }
    }
    
    func getShadowView() -> UIView? {
        if let viewArray = self.superview?.subviews {
            for sView in viewArray {
                if sView.tag == Int.max - 1 {
                    return sView
                }
            }
        }
        return nil
    }
}
