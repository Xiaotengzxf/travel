//
//  JMyOrderTableViewCell.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var pView: UIView!
    @IBOutlet weak var hView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var bottomHeightLConstraint: NSLayoutConstraint!
    
    weak var delegate: JMyOrderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pView.clipsToBounds = true
        pView.layer.cornerRadius = 7
        pView.layer.borderWidth = 1
        pView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        iconImageView.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "F5F5F5")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func payOrder(_ sender: Any) {
        delegate?.payOrder(tag: tag)
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        delegate?.cancelOrder(tag: tag)
    }
    
    @IBAction func joinCircle(_ sender: Any) {
        
    }
}

protocol JMyOrderTableViewCellDelegate: NSObjectProtocol {
    func payOrder(tag: Int)
    func cancelOrder(tag: Int)
}
