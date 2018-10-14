//
//  JMyOrderDetailViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JMyOrderDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var reserverLabel: UILabel!
    @IBOutlet weak var orderInfoView: UIView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var orderPayLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var scrollViewBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var orderCreateTimeLabel: UILabel!
    @IBOutlet weak var contactViewHeightConstraint: NSLayoutConstraint!
    
    private let service = JMyOrderDetailModelService()
    private var orderId = ""
    private var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JHUD.show(at: view)
        service.getMyOrderDetail(orderId: orderId) {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result != nil {
                self?.order = result
                self?.refreshUI()
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func intentData(orderId: String) {
        self.orderId = orderId
    }
    
    /// 刷新UI
    private func refreshUI() {
        let count = order?.activityEnterContactList?.count ?? 0
        for i in 0..<count {
            let userInfoView = Bundle.main.loadNibNamed("JUserInfoView", owner: nil, options: nil)!.first as! JUserInfoView
            userInfoView.translatesAutoresizingMaskIntoConstraints = false
            contactView.addSubview(userInfoView)
            
            contactView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : userInfoView]))
            
            contactView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(value)-[view(203)]", options: .directionLeadingToTrailing, metrics: ["value" : CGFloat(i * 11 + i * 203)], views: ["view" : userInfoView]))
            
            if let value = order?.activityEnterContactList?[i] {
                refreshContact(value: value, view: userInfoView)
            }
            
        }
        
        contactViewHeightConstraint.constant = CGFloat((11 + 203) * count)
        refreshSubview()
    }
    
    private func refreshSubview() {
        orderNoLabel.text = order?.id
        orderCreateTimeLabel.text = (Int(order?.createTime ?? 0) / 1000).toDateB()
        payButton.isHidden = !(order?.payStatus == "unpaid")
        
        if order?.payStatus == "cancle" {
            orderStateLabel.text = "已取消"
            orderStateLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "666666")
        } else if order?.payStatus == "unpaid" {
            orderStateLabel.text = "待付款"
            orderStateLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "FF3B30")
            scrollViewBottomLConstraint.constant = -50
        }
        orderNumLabel.text = "\(order?.people ?? 0)人"
        orderPriceLabel.text = "¥\(order?.activity?.fee ?? 0)"
        orderPayLabel.text = "¥\(order?.activity?.depositAmount ?? 0)"
        if let url = order?.activity?.imageUrl, url.count > 0 {
            iconImageView.kf.setImage(with: URL(string: url))
        } else {
            iconImageView.image = nil
        }
    }
    
    private func refreshContact(value: ActivityEnterContact, view: JUserInfoView) {
        view.nameLabel.text = value.realName
        view.identificationLabel.text = value.idCardNumber
        view.phoneLabel.text = value.mobilePhone
        if value.type == "man" {
            view.secialLabel.text = "成人"
        } else if value.type == "elder" {
            view.secialLabel.text = "老人"
        } else {
            view.secialLabel.text = "儿童"
        }
    }

    @IBAction func payOrCancelOrder(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JPayActionViewController") as? JPayActionViewController {
            viewController.order = order!
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}
