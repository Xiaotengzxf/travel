//
//  JCallUSTableViewCell.swift
//  Jouz
//
//  Created by ANKER on 2018/6/3.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCallUSTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameAndTimeLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameAndTimeLabel.textColor = c3
        nameAndTimeLabel.font = t4
        lineImageView.backgroundColor = c6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
