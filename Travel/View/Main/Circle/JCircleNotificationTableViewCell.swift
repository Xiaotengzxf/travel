//
//  JCircleNotificationTableViewCell.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCircleNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var conViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: JCircleNotificationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func showButton(value: Bool) {
        if value {
            agreeButton.isHidden = false
            rejectButton.isHidden = false
            statusLabel.isHidden = true
            conViewHeightConstraint.constant = 108
        } else {
            agreeButton.isHidden = true
            rejectButton.isHidden = true
            statusLabel.isHidden = false
            conViewHeightConstraint.constant = 75
        }
    }

    @IBAction func agree(_ sender: Any) {
        delegate?.agree(tag: tag)
    }
    
    @IBAction func reject(_ sender: Any) {
        delegate?.reject(tag: tag)
    }
}

protocol JCircleNotificationTableViewCellDelegate: NSObjectProtocol {
    func agree(tag: Int)
    func reject(tag: Int)
}
