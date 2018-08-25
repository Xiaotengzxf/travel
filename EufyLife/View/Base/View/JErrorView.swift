//
//  JErrorView.swift
//  Jouz
//
//  Created by ANKER on 2018/6/4.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JErrorView: UIView {

    @IBOutlet weak var descLabel: UILabel!
    weak var delegate: JErrorViewDelegate?

    @IBAction func closeSelf(_ sender: Any) {
        delegate?.closeErrorView()
    }
}

protocol JErrorViewDelegate: NSObjectProtocol {
    func closeErrorView()
}
