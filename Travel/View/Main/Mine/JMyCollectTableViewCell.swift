//
//  JMyCollectTableViewCell.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyCollectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var leftViewWidthLConstraint: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tapLeftButton(_ sender: Any) {
        leftButton.isSelected = !leftButton.isSelected
        priceLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: leftButton.isSelected ? "FF3B30" :  "666666" )
    }
    
    // MARK: - Public
    
    public func showLeftView(value: Bool) {
        leftView.isHidden = !value
        leftViewWidthLConstraint.constant = value ? 44 : 11
    }
}
