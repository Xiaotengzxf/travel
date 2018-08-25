//
//  JMainTableViewCell.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/9.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMainTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var bmiView: UIView!
    @IBOutlet weak var fatView: UIView!
    @IBOutlet weak var moreDataButton: UIButton!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalTipLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiTipLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatTipLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var scaleNameLabel: UILabel!
    @IBOutlet weak var connnectStatusLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    weak var delegate: JMainTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubViewPropertyValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        deviceView.layer.cornerRadius = 20
        deviceView.backgroundColor = c7
        deviceView.clipsToBounds = true
        scaleImageView.image = UIImage(named: "homepage_image_scale")
        
        moreDataButton.setTitle("More Data", for: .normal)
        moreDataButton.setTitleColor(c3, for: .normal)
        moreDataButton.titleLabel?.font = t3
        
        goalView.layer.cornerRadius = 14
        bmiView.layer.cornerRadius = 14
        fatView.layer.cornerRadius = 14
        
        goalLabel.textColor = c2
        goalLabel.font = UIFont.systemFont(ofSize: 36)
        goalTipLabel.textColor = c2
        goalTipLabel.font = ZFontManager.sharedInstance.getOtherFont(font: .t5)
        
        bmiLabel.textColor = c2
        bmiLabel.font = UIFont.systemFont(ofSize: 36)
        bmiTipLabel.textColor = c2
        bmiTipLabel.font = ZFontManager.sharedInstance.getOtherFont(font: .t5)
        
        fatLabel.textColor = c2
        fatLabel.font = UIFont.systemFont(ofSize: 36)
        fatTipLabel.textColor = c2
        fatTipLabel.font = ZFontManager.sharedInstance.getOtherFont(font: .t5)
        
        goalLabel.text = "--"
        goalTipLabel.text = "MY GOAL"
        bmiLabel.text = "--"
        bmiTipLabel.text = "BMI"
        fatLabel.text = "--%"
        fatTipLabel.text = "BODY FAT"
        
        editButton.setTitleColor(c1, for: .normal)
        editButton.titleLabel?.font = t3
        editButton.setTitle("edit", for: .normal)
        
        scaleNameLabel.text = "Eufy Smart Scale"
        scaleNameLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "427C79")
        scaleNameLabel.font = t2
        
        connnectStatusLabel.textColor = c8
        connnectStatusLabel.font = ZFontManager.sharedInstance.getOtherFont(font: .t5)
        connnectStatusLabel.text = "Disconnecting"
        
        weightLabel.textColor = c8
        weightLabel.font = UIFont.systemFont(ofSize: 55)
        weightLabel.text = "--"
        
        unitLabel.textColor = c8
        unitLabel.font = ZFontManager.sharedInstance.getOtherFont(font: .t5)
        unitLabel.text = "Kg"
    }
    
    // MARK: - Public
    
    public func refreshData(connectStatus: String) {
        connnectStatusLabel.text = connectStatus
    }
    
    public func refreshScaleData(weight: String) {
        weightLabel.text = weight
    }
    
    public func refreshData(goal: String, bmi: String, fat: String) {
        goalLabel.text = goal
        bmiLabel.text = bmi
        fatLabel.text = fat
    }
    
    public func refreshData(device: Device) {
        scaleNameLabel.text = device.name
    }

    @IBAction func pushToMoreData(_ sender: Any) {
        
    }
    
    @IBAction func editMyGoal(_ sender: Any) {
        
    }
    
    @IBAction func tapMore(_ sender: Any) {
        delegate?.tapMore(tag: tag)
    }
}

protocol JMainTableViewCellDelegate: NSObjectProtocol {
    func tapMore(tag: Int)
}
