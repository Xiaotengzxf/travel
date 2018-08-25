//
//  JRetrySearchViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/5/3.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRetrySearchViewController: SCBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    weak var delegate: JRetrySearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViewPropertyValue()
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshText()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func refreshText() {
        let message = "cnn_searching_error_tips".localized()
        let array = message.components(separatedBy: "^^")
        titleLabel.text = array[0]
        descLabel.text = array[1]
        tryAgainButton.setTitle("cnn_searching_retry".localized(), for: .normal)
    }
    
    private func setSubViewPropertyValue() {
        titleLabel.textColor = c2
        titleLabel.font = t1
        
        descLabel.textColor = c2
        descLabel.font = t3
        
        let size = CGSize(width: screenWidth - 80, height: 54)
        tryAgainButton.setBackground(size: size, cornerRadius: 27, addShadow: false)
    
    }
    
    private func getGradientBorder(size: CGSize) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: size)
        gradient.colors = [c_button_normal_left.cgColor, c_button_normal_right.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: 14).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        return gradient
    }

    // MARK: - Action
    
    @IBAction func retrySearch(_ sender: Any) {
        NotificationCenter.default.post(name: kBluetoothSettingsNotification, object: kBlueToothScan, userInfo: [kBlueToothScan : true, bWait: false])
        delegate?.callbackForRemoveSelf()
    }
}

protocol JRetrySearchViewControllerDelegate: NSObjectProtocol {
    func callbackForRemoveSelf()
}
