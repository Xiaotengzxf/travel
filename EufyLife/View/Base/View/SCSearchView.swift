//
//  SCSearchView.swift
//  Jouz
//
//  Created by ANKER on 2018/3/9.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCSearchView: UIView {
    
    @IBOutlet weak var waterWaveView: UIView!
    @IBOutlet weak var greenImageView: UIImageView!
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var waterWaveViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var greenXLConstraint: NSLayoutConstraint!
    @IBOutlet weak var greenYLConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueXLConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueYLConstraint: NSLayoutConstraint!
    
    private let waterWaveWidth : CGFloat = 190 * scale
    private let waterRippleView1PreWidth : CGFloat = 240 * scale
    private let waterRippleView2PreWidth : CGFloat = 280 * scale
    private let waterRippleView3PreWidth : CGFloat = 320 * scale
    private let waterRippleView1Width : CGFloat = 270 * scale
    private let waterRippleView2Width : CGFloat = 300 * scale
    private let waterRippleView3Width : CGFloat = 340 * scale
    private let waterRippleView1SufWidth : CGFloat = 300 * scale
    private let waterRippleView2SufWidth : CGFloat = 540 * scale
    private let waterRippleView3SufWidth : CGFloat = 700 * scale
    
    var waterWaveTimer: Timer?
    
    var waterRippleView1: UIView!
    var waterRippleView2: UIView!
    var waterRippleView3: UIView!
    private var color = ZColorManager.sharedInstance.colorWithHexString(hex: "DDDDDD")
    
    private let waterWaveRadius = 90

    override func awakeFromNib() {
        super.awakeFromNib()
        searchLabel.textAlignment = .center
        
        waterWaveViewWidthConstraint.constant = waterWaveWidth
        
        addWaterRipple()
        
        searchLabel.font = t4
        searchLabel.textColor = c2
    }
    
    func setText() {
        searchLabel.text = "cnn_searching_text".localized()
    }
    
    private func addWaterRipple() {
        waterRippleView1 = UIView(frame: CGRect(x: -(waterRippleView1Width - waterWaveWidth) / 2, y: -(waterRippleView1Width - waterWaveWidth) / 2, width: waterRippleView1Width, height: waterRippleView1Width))
        waterRippleView1?.layer.cornerRadius = CGFloat(waterRippleView1Width / 2)
        waterRippleView1?.layer.borderColor = color.cgColor
        waterRippleView1?.layer.borderWidth = 1
        waterWaveView.insertSubview(waterRippleView1!, belowSubview: greenImageView)
        
        waterRippleView2 = UIView(frame: CGRect(x: -(waterRippleView2Width - waterWaveWidth) / 2, y: -(waterRippleView2Width - waterWaveWidth) / 2, width: waterRippleView2Width, height: waterRippleView2Width))
        waterRippleView2?.layer.cornerRadius = CGFloat(waterRippleView2Width / 2)
        waterRippleView2?.layer.borderColor = color.cgColor
        waterRippleView2?.layer.borderWidth = 0.5
        waterWaveView.insertSubview(waterRippleView2!, belowSubview: waterRippleView1!)
        
        waterRippleView3 = UIView(frame: CGRect(x: -(waterRippleView3Width - waterWaveWidth) / 2, y: -(waterRippleView3Width - waterWaveWidth) / 2, width: waterRippleView3Width, height: waterRippleView3Width))
        waterRippleView3?.layer.cornerRadius = CGFloat(waterRippleView3Width / 2)
        waterRippleView3?.layer.borderColor = color.cgColor
        waterRippleView3?.layer.borderWidth = 0.5
        waterWaveView.insertSubview(waterRippleView3!, belowSubview: waterRippleView2!)
        
        waterRippleView1.alpha = 0
        waterRippleView2.alpha = 0
        waterRippleView3.alpha = 0
    }
    
    // 设置水波纹动画
    @objc private func waterRippleAnimation(){
        waterRippleView1.transform = CGAffineTransform(scaleX: waterRippleView1PreWidth / waterRippleView1Width, y: waterRippleView1PreWidth / waterRippleView1Width)
        waterRippleView2.transform = CGAffineTransform(scaleX: waterRippleView1PreWidth / waterRippleView1Width, y: waterRippleView1PreWidth / waterRippleView1Width)
        waterRippleView3.transform = CGAffineTransform(scaleX: waterRippleView1PreWidth / waterRippleView1Width, y: waterRippleView1PreWidth / waterRippleView1Width)
        self.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            [weak self] in
            self?.waterRippleView1?.transform = CGAffineTransform.identity
            self?.waterRippleView2?.transform = CGAffineTransform.identity
            self?.waterRippleView3?.transform = CGAffineTransform.identity
            self?.waterRippleView1?.alpha = 1
            self?.waterRippleView2?.alpha = 1
            self?.waterRippleView3?.alpha = 1
            self?.greenImageView.transform = CGAffineTransform(translationX: -12, y: 12)
            self?.blueImageView.transform = CGAffineTransform(translationX: 12, y: -12)
        }) {[weak self] (finished) in
            self?.hideWaterView()
        }
    }
    
    private func hideWaterView() {
        UIView.animate(withDuration: 1.6, delay: 0, options: .curveEaseOut, animations: {
            [weak self] in
            self?.waterRippleView1?.transform = CGAffineTransform(scaleX: self!.waterRippleView1SufWidth / self!.waterRippleView1Width, y: self!.waterRippleView1SufWidth / self!.waterRippleView1Width)
            self?.waterRippleView2?.transform = CGAffineTransform(scaleX: self!.waterRippleView2SufWidth / self!.waterRippleView2Width, y: self!.waterRippleView2SufWidth / self!.waterRippleView2Width)
            self?.waterRippleView3?.transform = CGAffineTransform(scaleX: self!.waterRippleView3SufWidth / self!.waterRippleView3Width, y: self!.waterRippleView3SufWidth / self!.waterRippleView3Width)
            self?.waterRippleView1?.alpha = 0.0
            self?.waterRippleView2?.alpha = 0.0
            self?.waterRippleView3?.alpha = 0.0
            self?.greenImageView.transform = CGAffineTransform.identity
            self?.blueImageView.transform = CGAffineTransform.identity
        }) {[weak self] (finished) in
            self?.waterRippleView1?.transform = CGAffineTransform.identity
            self?.waterRippleView2?.transform = CGAffineTransform.identity
            self?.waterRippleView3?.transform = CGAffineTransform.identity
        }
    }
    
    func startAnimation() {
        if waterWaveTimer == nil {
            waterWaveTimer = Timer.scheduledTimer(timeInterval: 2.01, target: self, selector: #selector(waterRippleAnimation), userInfo: nil, repeats: true)
            waterWaveTimer?.fire()
            RunLoop.main.add(waterWaveTimer!, forMode: .commonModes)
        }
    }
    
    func stopAnimation() {
        waterWaveTimer?.invalidate()
        waterWaveTimer = nil
    }

}
