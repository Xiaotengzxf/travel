//
//  SGCirleProgress.swift
//  SGCirleProgress
//
//  Created by SeanGao on 2018/1/9.
//  Copyright © 2018年 SeanGao. All rights reserved.
//

import UIKit

class SGCirleProgress: UIView {

    private var circle: SGCirle!
    private var percentLabel: UILabel!
    
    var progress: CGFloat = 0 {
        didSet {
            let nValue = Int(floor(progress * 100))
            circle.progress = CGFloat(nValue) / 100
            percentLabel.text = "\(nValue)%"
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.clear
        let lineWidth: CGFloat = 6
        percentLabel = UILabel(frame: self.bounds)
        percentLabel.textColor = c2
        percentLabel.textAlignment = .center
        percentLabel.font = t2
        percentLabel.text = "0%"
        self.addSubview(percentLabel)
        
        circle = SGCirle(frame: self.bounds, lineWidth: lineWidth)
        self.addSubview(circle)
    }
    
    public func setBackLayerColor(color: UIColor) {
        circle.setBackLayerColor(color: color)
    }
    
}
