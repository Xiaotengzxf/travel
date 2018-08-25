//
//  JMultiSelectTableViewCell.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMultiSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    //private var
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviewPropertyValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Private
    
    private func setSubviewPropertyValue() {
        contentView.backgroundColor = c7
        deviceView.backgroundColor = c8
        deviceView.layer.cornerRadius = 14
        
        deviceNameLabel.textColor = c3
        deviceNameLabel.font = t2
    }
    
    // MARK: - Public
    
    public func refreshUI(name: String) {
        deviceNameLabel.text = name
        selectedImageView.image = UIImage(named: isSelected ? "adddevice_cion_circlesel" : "add device_icon_circle")
    }
}
