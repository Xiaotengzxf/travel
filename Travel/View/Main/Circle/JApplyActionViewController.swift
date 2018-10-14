//
//  JApplyActionViewController.swift
//  Travel
//
//  Created by ANKER on 2018/11/21.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JApplyActionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var adultUnitPriceLabel: UILabel!
    @IBOutlet weak var adultMinusButton: UIButton!
    @IBOutlet weak var adultAddButton: UIButton!
    @IBOutlet weak var adultNumberLabel: UILabel!
    @IBOutlet weak var adultTotalLabel: UILabel!
    @IBOutlet weak var oldUnitPriceLabel: UILabel!
    @IBOutlet weak var oldMinusButton: UIButton!
    @IBOutlet weak var oldAddButton: UIButton!
    @IBOutlet weak var oldNumberLabel: UILabel!
    @IBOutlet weak var oldTotalLabel: UILabel!
    @IBOutlet weak var childUnitPriceLabel: UILabel!
    @IBOutlet weak var childNumberLabel: UILabel!
    @IBOutlet weak var childMinusButton: UIButton!
    @IBOutlet weak var childAddButton: UIButton!
    @IBOutlet weak var childTotalLabel: UILabel!
    @IBOutlet weak var payAllButton: UIButton!
    @IBOutlet weak var payAllLabel: UILabel!
    @IBOutlet weak var payDepositButton: UIButton!
    @IBOutlet weak var payDepositLabel: UILabel!
    @IBOutlet weak var addCommonContactButton: UIButton!
    @IBOutlet weak var addPeopleInfoView: UIView!
    @IBOutlet weak var bookerNameTextField: UITextField!
    
    @IBOutlet weak var bookerPhoneTextField: UITextField!
    
    @IBOutlet weak var gatherLocationTextField: UITextField!
    @IBOutlet weak var orderRemarkTextField: UITextView!
    
    @IBOutlet weak var addPeopleInfoViewHeightLConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPeopleInfoViewBottomLCosntraint: NSLayoutConstraint!
    private var adultCount = 0
    private var oldCount = 0
    private var childCount = 0
    private var topLConstraints : [Int : NSLayoutConstraint] = [:]
    private var activity: Activity!
    private var activityContent : [String : Any] = [:]
    private var currentApplyActionPeopleView: JApplyActionPeopleView?
    private let service  = JApplyActionModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "【周四】\(activity.city ?? "").\(activity.district ?? "").\(activity.title ?? "")"
        timeLabel.text = "\(activity.startTime ?? "")-\(activity.endTime ?? "")"
        adultUnitPriceLabel.text = "¥\(activity.fee ?? 0)"
        adultNumberLabel.text = "0"
        adultTotalLabel.text = "¥0"
        oldUnitPriceLabel.text = "¥\(activity.feeElder ?? 0)"
        oldNumberLabel.text = "0"
        oldTotalLabel.text = "¥0"
        childUnitPriceLabel.text = "¥\(activity.feeChild ?? 0)"
        childNumberLabel.text = "0"
        childTotalLabel.text = "¥0"
        
        payAllLabel.text = "¥0"
        payDepositLabel.text = "¥0"
        
        addCommonContactButton.setTitle("常用联系人", for: .normal)
        
        orderRemarkTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "F5F5F5").cgColor
        orderRemarkTextField.layer.borderWidth = 1
        orderRemarkTextField.layer.cornerRadius = 3.5
        orderRemarkTextField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Public
    
    public func intentData(activity: Activity) {
        self.activity = activity
    }

    @IBAction func adultMinus(_ sender: Any) {
        let num = Int(adultNumberLabel.text ?? "0") ?? 0
        if num > 0 {
            adultNumberLabel.text = "\(num - 1)"
            let fee = activity.fee ?? 0
            adultTotalLabel.text = "¥\(Float(num - 1) * fee)"
            if let view = addPeopleInfoView.viewWithTag(adultCount) as? JApplyActionPeopleView {
                view.removeFromSuperview()
            }
            adultCount -= 1
            let count = adultCount + oldCount + childCount
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * count + 10 * max(0, count - 1))
            if oldCount > 0 {
                for i in 0..<oldCount {
                    if let constraint = topLConstraints[(i + 1) * 100] {
                        constraint.constant -= 193
                    }
                }
            }
            if childCount > 0 {
                for i in 0..<childCount {
                    if let constraint = topLConstraints[(i + 1) * 10000] {
                        constraint.constant -= 193
                    }
                }
            }
            if count == 0 {
                addPeopleInfoViewBottomLCosntraint.constant = 0
            }
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
    }
    
    @IBAction func adultAdd(_ sender: Any) {
        adultCount += 1
        adultNumberLabel.text = "\(adultCount)"
        let fee = activity.fee ?? 0
        adultTotalLabel.text = "¥\(Float(adultCount) * fee)"
        if let view = Bundle.main.loadNibNamed("JApplyActionPeopleView", owner: nil, options: nil)?.first as? JApplyActionPeopleView {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = adultCount
            view.delegate = self
            view.type = "man"
            addPeopleInfoView.addSubview(view)
            view.titleLabel.text = "成人"
            let count = adultCount + oldCount + childCount - 1
            addPeopleInfoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(11)-[view]-(11)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : view]))
            addPeopleInfoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[view]", options: .directionLeadingToTrailing, metrics: ["top" : 183 * count + 10 * count], views: ["view" : view]))
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * (count + 1) + 10 * count)
            
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count + 1) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
        addPeopleInfoViewBottomLCosntraint.constant = 10
    }
    
    @IBAction func oldMinus(_ sender: Any) {
        let num = Int(oldNumberLabel.text ?? "0") ?? 0
        if num > 0 {
            oldNumberLabel.text = "\(num - 1)"
            let fee = activity.fee ?? 0
            oldTotalLabel.text = "¥\(Float(num - 1) * fee)"
            if let view = addPeopleInfoView.viewWithTag(oldCount * 100) as? JApplyActionPeopleView {
                view.removeFromSuperview()
            }
            topLConstraints.removeValue(forKey: oldCount * 100)
            oldCount -= 1
            let count = adultCount + oldCount + childCount
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * count + 10 * max(0, count - 1))
            if childCount > 0 {
                for i in 0..<childCount {
                    if let constraint = topLConstraints[(i + 1) * 10000] {
                        constraint.constant -= 193
                    }
                }
            }
            if count == 0 {
                addPeopleInfoViewBottomLCosntraint.constant = 0
            }
            
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
    }
    
    @IBAction func oldAdd(_ sender: Any) {
        oldCount += 1
        oldNumberLabel.text = "\(oldCount)"
        let fee = activity.fee ?? 0
        oldTotalLabel.text = "¥\(Float(oldCount) * fee)"
        if let view = Bundle.main.loadNibNamed("JApplyActionPeopleView", owner: nil, options: nil)?.first as? JApplyActionPeopleView {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = oldCount * 100
            addPeopleInfoView.addSubview(view)
            view.titleLabel.text = "老人"
            view.type = "edler"
            view.delegate = self
            let count = adultCount + oldCount + childCount - 1
            addPeopleInfoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(11)-[view]-(11)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : view]))
            let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: addPeopleInfoView, attribute: .top, multiplier: 1, constant: CGFloat(183 * count + 10 * count))
            addPeopleInfoView.addConstraint(constraint)
            topLConstraints[oldCount * 100] = constraint
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * (count + 1) + 10 * count)
            
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count + 1) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
        addPeopleInfoViewBottomLCosntraint.constant = 10
    }
    
    @IBAction func childMinus(_ sender: Any) {
        let num = Int(childNumberLabel.text ?? "0") ?? 0
        if num > 0 {
            childNumberLabel.text = "\(num - 1)"
            let fee = activity.feeChild ?? 0
            childTotalLabel.text = "¥\(Float(num - 1) * fee)"
            if let view = addPeopleInfoView.viewWithTag(childCount * 10000) as? JApplyActionPeopleView {
                view.removeFromSuperview()
            }
            topLConstraints.removeValue(forKey: childCount * 10000)
            childCount -= 1
            let count = adultCount + oldCount + childCount
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * count + 10 * max(0, count - 1))
            if count == 0 {
                addPeopleInfoViewBottomLCosntraint.constant = 0
            }
            
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
    }
    
    @IBAction func childAdd(_ sender: Any) {
        childCount += 1
        childNumberLabel.text = "\(childCount)"
        let fee = activity.feeChild ?? 0
        childTotalLabel.text = "¥\(Float(childCount) * fee)"
        if let view = Bundle.main.loadNibNamed("JApplyActionPeopleView", owner: nil, options: nil)?.first as? JApplyActionPeopleView {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = childCount * 10000
            addPeopleInfoView.addSubview(view)
            view.titleLabel.text = "儿童"
            view.delegate = self
            view.type = "child"
            let count = adultCount + oldCount + childCount - 1
            addPeopleInfoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(11)-[view]-(11)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : view]))
            let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: addPeopleInfoView, attribute: .top, multiplier: 1, constant: CGFloat(183 * count + 10 * count))
            addPeopleInfoView.addConstraint(constraint)
            topLConstraints[childCount * 10000] = constraint
            addPeopleInfoViewHeightLConstraint.constant = CGFloat(183 * (count + 1) + 10 * count)
            
            let adultTotal = Float(adultCount) * (activity.fee ?? 0)
            let olderTotal = Float(oldCount) * (activity.fee ?? 0)
            let childTotal = Float(childCount) * (activity.feeChild ?? 0)
            let total = adultTotal + olderTotal + childTotal
            payAllLabel.text = "¥\(total)"
            let deposit = Float(count + 1) * (activity.depositAmount ?? 0)
            payDepositLabel.text = "¥\(deposit)"
        }
        addPeopleInfoViewBottomLCosntraint.constant = 10
    }
    
    @IBAction func payAll(_ sender: Any) {
        if !payAllButton.isSelected {
            payAllButton.isSelected = true
            payDepositButton.isSelected = false
            payAllLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "FF3B30")
            payDepositLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "333333")
            activityContent["payType"] = "online"
        }
    }
    
    @IBAction func payDeposit(_ sender: Any) {
        if !payDepositButton.isSelected {
            payAllButton.isSelected = false
            payDepositButton.isSelected = true
            payAllLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "333333")
            payDepositLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "FF3B30")
            activityContent["payType"] = "onlineDeposit"
        }
    }
    
    @IBAction func addCommonContact(_ sender: Any) {
        // 调整至联系人列表
        let storyboard = UIStoryboard(name: "Contacts", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "JCommonContactsViewController") as? JCommonContactsViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        
        guard let contact = bookerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), contact.count > 0  else {
            Toast(text: "请输入预订人姓名").show()
            return
        }
        activityContent["emergencyContact"] = contact
        guard let contactPhone = bookerPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), contact.count > 0  else {
            Toast(text: "请输入预订人联系电话").show()
            return
        }
        activityContent["emergencyContactPhone"] = contactPhone
        activityContent["activityId"] = activity.id ?? ""
        activityContent["circleId"] = activity.circleId ?? ""
        activityContent["depositAmount"] = activity.depositAmount ?? 0
        
        if activityContent.count > 0 {
            JHUD.show(at: self.view)
            service.applyAction(content: activityContent) {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if let order = result {
                    if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "JPayActionViewController") as? JPayActionViewController {
                        viewController.order = order
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
    
}


// MARK: - 实现新增用户快速类型

extension JApplyActionViewController: JApplyActionPeopleViewDelegate {
    func choosePeople(_ view: JApplyActionPeopleView, type: String?) {
        currentApplyActionPeopleView = view
        let storyboard = UIStoryboard(name: "Contacts", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "JCommonContactsViewController") as? JCommonContactsViewController {
            viewController.intentData(type: type)
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension JApplyActionViewController: JCommonContactsViewControllerDelegate {
    func choose(type: String?, model: JCommonContactModel) {
        var list = activityContent["activityEnterContactList"] as? [[String : String]] ?? []
        list.append(["idCardNumber": model.idCardNumber ?? "",
                      "mobilePhone": model.mobilePhone ?? "",
                      "realName": model.realName ?? "",
                      "type": model.type ?? ""])
        activityContent["activityEnterContactList"] = list
        if model.type == "man" {
            currentApplyActionPeopleView?.titleLabel.text = "成人"
        } else if model.type == "child" {
            currentApplyActionPeopleView?.titleLabel.text = "儿童"
        } else {
            currentApplyActionPeopleView?.titleLabel.text = "老人"
        }
        currentApplyActionPeopleView?.nameTextField.text = model.realName
        currentApplyActionPeopleView?.phoneTextField.text = model.mobilePhone
        currentApplyActionPeopleView?.identifyCardTextField.text = model.idCardNumber
    }
    
    
}

extension JApplyActionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "输入" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "" {
            textView.text = "输入"
        }
    }
}
