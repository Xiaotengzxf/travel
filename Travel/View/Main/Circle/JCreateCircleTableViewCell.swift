//
//  JCreateCircleTableViewCell.swift
//  Travel
//
//  Created by ANKER on 2018/11/3.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCreateCircleTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
