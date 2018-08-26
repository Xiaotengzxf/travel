//
//  SGCirle.swift
//  SGCirleProgress
//
//  Created by SeanGao on 2018/1/9.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

import UIKit

class SGCirle: UIView {

    var lineWidth_: CGFloat!
    
    private var backLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
            progressLayer.removeAllAnimations()
        }
    }
    
    init(frame: CGRect, lineWidth: CGFloat) {
        super.init(frame: frame)
        lineWidth_ = lineWidth
        self.buildLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildLayout() {
        let centerX:CGFloat = self.bounds.size.width / 2.0
        let centerY:CGFloat = self.bounds.size.height / 2.0
        let radius:CGFloat = (self.bounds.size.width - lineWidth_) / 2.0;
        
        let path:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        backLayer = CAShapeLayer()
        backLayer.frame = self.bounds
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.strokeColor = UIColor.clear.cgColor
        backLayer.lineWidth = lineWidth_
        backLayer.path = path.cgPath
        backLayer.strokeEnd = 1
        self.layer.addSublayer(backLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor  = UIColor.blue.cgColor;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.lineWidth = lineWidth_
        progressLayer.path = path.cgPath
        progressLayer.strokeEnd = 0
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [c_button_normal_right.cgColor, c_button_normal_left.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer.endPoint = CGPoint(x: 0, y: 1);
        gradientLayer.mask = progressLayer
        self.layer.addSublayer(gradientLayer)
        
    }
    
    public func setBackLayerColor(color: UIColor) {
        backLayer.strokeColor = color.cgColor
    }
    
}
