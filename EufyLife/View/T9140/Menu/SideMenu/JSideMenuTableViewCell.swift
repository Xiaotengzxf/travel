//
//  JSideMenuTableViewCell.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var lineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setSubViewPropertyValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Public
    public func refreshData(name: String, imageName: String) {
        nameLabel.text = name
        iconImageView.image = UIImage(named: imageName)
    }
    
    // MARK: Private
    
    private func setSubViewPropertyValue() {
        nameLabel.textColor = c2
        nameLabel.font = t3
        lineImageView.backgroundColor = c6
        arrowImageView.image = UIImage(named: "common_icon_arrow")
    }

}
