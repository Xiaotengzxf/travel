//
//  UIView+RedPoint.swift
//  RedPoint
//
//  Created by SeanGao on 2018/1/17.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func showRedPoint() {
        self.removeRedPoint()
        let badgeView:UIView = UIView()
        badgeView.tag = 996
        let viewWidth: CGFloat = 8
        badgeView.layer.cornerRadius = viewWidth / 2
        badgeView.backgroundColor = UIColor.red
        badgeView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: viewWidth, height: viewWidth))
        self.addSubview(badgeView)
    }
    
    public func showRedPointForRoundButton(offset: CGPoint? = nil) {
        self.removeRedPoint()
        let badgeView:UIView = UIView()
        badgeView.tag = 996
        let viewWidth: CGFloat = 8
        badgeView.layer.cornerRadius = viewWidth / 2
        badgeView.backgroundColor = UIColor.red
        badgeView.frame = CGRect(origin: CGPoint(x: offset?.x ?? 0, y: offset?.y ?? 0), size: CGSize(width: viewWidth, height: viewWidth))
        self.addSubview(badgeView)
    }
    
    /// 隐藏小红点
    public func hideRedPoint() {
        self.removeRedPoint()
    }
    
    // 移除小红点
    private func removeRedPoint() {
        for subView in self.subviews {
            if subView.tag == 996 {
                subView.removeFromSuperview()
            }
        }
    }
    
}
