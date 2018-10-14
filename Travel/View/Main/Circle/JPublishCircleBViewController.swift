//
//  JPublishCircleBViewController.swift
//  Travel
//
//  Created by ANKER on 2018/10/14.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JPublishCircleBViewController: UIViewController {

    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var outStartTimeTextField: UITextField!
    @IBOutlet weak var outEndTimeTextField: UITextField!
    @IBOutlet weak var activityTitleTextField: UITextField!
    @IBOutlet weak var onLinePayButton: UIButton!
    @IBOutlet weak var offLinePayButton: UIButton!
    @IBOutlet weak var headBView: UIView!
    @IBOutlet weak var adultFeeView: UIView!
    @IBOutlet weak var adultFeeTextField: UITextField!
    @IBOutlet weak var childFeeView: UIView!
    @IBOutlet weak var childFeeTextField: UITextField!
    @IBOutlet weak var depositFeeView: UIView!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var depositFeeTextField: UITextField!
    
    private var value: [String: Any] = [:]
    private var pickerA: UIDatePicker!
    private var pickerB: UIDatePicker!
    private var pickerC: UIDatePicker!
    private var pickerD: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let normalColor = ZColorManager.sharedInstance.colorWithHexString(hex: "ffffff")
        let selectedColor = ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7")
        onLinePayButton.setBackgroundImage(UIImage.getImageWithColor(color: normalColor), for: .normal)
        onLinePayButton.setBackgroundImage(UIImage.getImageWithColor(color: selectedColor), for: .selected)
        onLinePayButton.isSelected = true
        offLinePayButton.setBackgroundImage(UIImage.getImageWithColor(color: normalColor), for: .normal)
        offLinePayButton.setBackgroundImage(UIImage.getImageWithColor(color: selectedColor), for: .selected)
        
        let shaperLayer = CAShapeLayer()
        let bound = CGRect(x: 0, y: 0, width: screenWidth - 22, height: 140)
        shaperLayer.frame = bound
        let path = UIBezierPath(roundedRect: bound, byRoundingCorners: [.bottomLeft, .bottomRight] , cornerRadii: CGSize(width: 7, height: 7))
        shaperLayer.path = path.cgPath
        shaperLayer.strokeColor = selectedColor.cgColor
        shaperLayer.masksToBounds = true
        shaperLayer.fillColor = nil
        shaperLayer.lineWidth = 1
        shaperLayer.lineCap = "square"
        headBView.layer.addSublayer(shaperLayer)
        
        let colorA = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC")
        adultFeeView.layer.borderColor = colorA.cgColor
        childFeeView.layer.borderColor = colorA.cgColor
        depositFeeView.layer.borderColor = colorA.cgColor
        adultFeeView.layer.cornerRadius = 7
        childFeeView.layer.cornerRadius = 7
        depositFeeView.layer.cornerRadius = 7
        adultFeeView.layer.borderWidth = 0.5
        childFeeView.layer.borderWidth = 0.5
        depositFeeView.layer.borderWidth = 0.5

        let rightViewA = UIImageView(image: UIImage(named: "date_2"))
        rightViewA.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        rightViewA.contentMode = .center
        startTimeTextField.rightView = rightViewA
        startTimeTextField.rightViewMode = .always
        
        let rightViewB = UIImageView(image: UIImage(named: "date_2"))
        rightViewB.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        rightViewB.contentMode = .center
        endTimeTextField.rightView = rightViewB
        endTimeTextField.rightViewMode = .always

        let rightViewC = UIImageView(image: UIImage(named: "date_2"))
        rightViewC.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        rightViewC.contentMode = .center
        outStartTimeTextField.rightView = rightViewC
        outStartTimeTextField.rightViewMode = .always
        
        let rightViewD = UIImageView(image: UIImage(named: "date_2"))
        rightViewD.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        rightViewD.contentMode = .center
        outEndTimeTextField.rightView = rightViewD
        outEndTimeTextField.rightViewMode = .always

        stopTimeLabel.text = "退出\n截止日期"
        
        pickerA = UIDatePicker()
        pickerA.datePickerMode = .date
        startTimeTextField.inputView = pickerA
        startTimeTextField.addDoneOnKeyboardWithTarget(self, action: #selector(handleA))
        
        pickerB = UIDatePicker()
        pickerB.datePickerMode = .date
        outStartTimeTextField.inputView = pickerB
        outStartTimeTextField.addDoneOnKeyboardWithTarget(self, action: #selector(handleB))
        
        pickerC = UIDatePicker()
        pickerC.datePickerMode = .date
        endTimeTextField.inputView = pickerC
        endTimeTextField.addDoneOnKeyboardWithTarget(self, action: #selector(handleC))
        
        pickerD = UIDatePicker()
        pickerD.datePickerMode = .date
        outEndTimeTextField.inputView = pickerD
        outEndTimeTextField.addDoneOnKeyboardWithTarget(self, action: #selector(handleD))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JPublishCircleCViewController {
            vc.intent(value: value)
        }
    }
    
    // MARK: - Public
    
    public func intent(value: [String: Any]) {
        self.value = value
    }
    
    // MARK: - Action
    
    @IBAction func pushToNextStep(_ sender: Any) {
        
        guard let fee = adultFeeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请输入成人全额").show()
            return
        }
        
        guard let childFee = childFeeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请输入儿童全额").show()
            return
        }
        
        guard let deposit = depositFeeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请输入定金").show()
            return
        }
        
        guard let startTime = startTimeTextField.text else {
            Toast(text: "请选择活动时间").show()
            return
        }
        
        guard let endTime = endTimeTextField.text else {
            Toast(text: "请选择活动时间").show()
            return
        }
        
        guard let outStartTime = outStartTimeTextField.text else {
            Toast(text: "请选择退出截止日期").show()
            return
        }
        
        guard let num = activityTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请输入活动人数").show()
            return
        }
        value["enterMaxNumber"] = Int(num) ?? 0
        value["depositAmount"] = Float(deposit) ?? 0
        value["startTime"] = startTime + " 08:00"
        value["endTime"] = endTime + " 08:00"
        value["enterDeadline"] = outStartTime + " 08:00"
        value["payType"] = onLinePayButton.isSelected ? "onlineDeposit" : "offlineDeposit"
        value["fee"] = Float(fee) ?? 0
        value["feeChild"] = Float(childFee) ?? 0
        
        self.performSegue(withIdentifier: "PublishC", sender: self)
    }
    
    @IBAction func payOnLine(_ sender: Any) {
        offLinePayButton.isSelected = false
        onLinePayButton.isSelected = true
        depositFeeView.isHidden = false
        depositLabel.isHidden = false
    }
    
    @IBAction func payOffLine(_ sender: Any) {
        offLinePayButton.isSelected = true
        onLinePayButton.isSelected = false
        depositFeeView.isHidden = true
        depositLabel.isHidden = true
    }
    
    @objc private func handleA() {
        let date = pickerA.date
        startTimeTextField.text = dateToString(date: date)
        startTimeTextField.resignFirstResponder()
    }
    
    @objc private func handleB() {
        let date = pickerB.date
        outStartTimeTextField.text = dateToString(date: date)
        outStartTimeTextField.resignFirstResponder()
    }
    
    @objc private func handleC() {
        let date = pickerC.date
        endTimeTextField.text = dateToString(date: date)
        endTimeTextField.resignFirstResponder()
    }
    
    @objc private func handleD() {
        let date = pickerD.date
        outEndTimeTextField.text = dateToString(date: date)
        outEndTimeTextField.resignFirstResponder()
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension JPublishCircleBViewController: UITextFieldDelegate {
    
    
    
}
