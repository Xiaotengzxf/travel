//
//  SCBackButton.swift
//  Jouz
//
//  Created by SeanGao on 2018/1/25.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCBackButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        self.setImage(UIImage(named: "common_icon_back"), for: .normal)
        self.setTitle("common_title_back".localized(), for: .normal)
        self.titleLabel?.font = t3
        self.setTitleColor(c1, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
    }

}
