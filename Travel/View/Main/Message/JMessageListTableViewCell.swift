//
//  JMessageListTableViewCell.swift
//  Travel
//
//  Created by ANKER on 2018/9/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
