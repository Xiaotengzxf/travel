//
//  JActionInfoView.swift
//  Travel
//
//  Created by ANKER on 2018/10/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JActionInfoView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 3.5
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}

extension JActionInfoView: UITextFieldDelegate {
    
}

extension JActionInfoView: UITextViewDelegate {
    
}
