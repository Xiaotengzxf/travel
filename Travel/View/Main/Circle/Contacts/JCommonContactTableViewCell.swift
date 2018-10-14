//
//  JCommonContactTableViewCell.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCommonContactTableViewCell: UITableViewCell {
    
    var actionPeopleView: JApplyActionPeopleView!

    override func awakeFromNib() {
        super.awakeFromNib()
        actionPeopleView = Bundle.main.loadNibNamed("JApplyActionPeopleView", owner: nil, options: nil)?.first as? JApplyActionPeopleView
        actionPeopleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionPeopleView)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[view]-(10)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": actionPeopleView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[view]-(10)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": actionPeopleView]))
        actionPeopleView.layer.cornerRadius = 7
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshUI(model: JCommonContactModel) {
        if model.type == "man" {
            actionPeopleView.titleLabel.text = "成人"
        } else if model.type == "child" {
            actionPeopleView.titleLabel.text = "儿童"
        } else {
            actionPeopleView.titleLabel.text = "老人"
        }
        actionPeopleView.nameTextField.text = model.realName
        actionPeopleView.phoneTextField.text = model.mobilePhone
        actionPeopleView.identifyCardTextField.text = model.idCardNumber
        actionPeopleView.choosePeopleButton.setTitle("确定", for: .normal)
    }

}
