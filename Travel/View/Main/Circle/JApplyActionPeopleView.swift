//
//  JApplyActionPeopleView.swift
//  Travel
//
//  Created by ANKER on 2018/11/29.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JApplyActionPeopleView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var identifyCardTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var choosePeopleButton: UIButton!
    
    weak var delegate: JApplyActionPeopleViewDelegate?
    var type: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        choosePeopleButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        choosePeopleButton.layer.borderWidth = 0.5
    }
    
    @IBAction func choosePeople(_ sender: Any) {
        delegate?.choosePeople(self, type: type)
    }
    
}

protocol JApplyActionPeopleViewDelegate: NSObjectProtocol {
    func choosePeople(_ view: JApplyActionPeopleView, type: String?)
}
