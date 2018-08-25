//
//  CyclicCardCell.swift
//  CyclicCard
//
//  Created by Tony on 17/1/11.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class CyclicCardCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = c2
        titleLabel.font = t4
        iconTopConstraint.constant = screenWidth <= 320 ? 30 : 95
    }
    
}
