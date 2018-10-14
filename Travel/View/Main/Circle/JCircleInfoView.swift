//
//  JCircleInfoView.swift
//  Travel
//
//  Created by ANKER on 2018/10/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCircleInfoView: UIView {

    @IBOutlet weak var button: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func selectCircle(_ sender: Any) {
        button.isSelected = !button.isSelected
    }
}
