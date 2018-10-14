//
//  JMyOrderViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster
import Kingfisher

class JMyOrderViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var lineWidthLConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineLeadingLConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var service = JMyOrderModelService()
    private var tableData: [Order] = []
    private var orderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "666666")], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "000000")], for: .selected)
        lineWidthLConstraint.constant = 34
        lineLeadingLConstraint.constant = (screenWidth / 5 - 34) / 2
        
        tableView.rowHeight = UITableViewAutomaticDimension
        getMyOrderList(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? JMyOrderDetailViewController {
            viewController.intentData(orderId: orderId)
        }
    }

    @IBAction func valueChanged(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        var width : CGFloat = 0
        if index == 0 || index == 3 {
            width = 34
        } else {
            width = 49
        }
        lineWidthLConstraint.constant = width
        lineLeadingLConstraint.constant = CGFloat(index) * screenWidth / 5 + (screenWidth / 5 - width) / 2
        getMyOrderList(index: index)
    }
    
    /// 获取订单列表
    ///
    /// - Parameter index: 不同类别
    private func getMyOrderList(index: Int) {
        JHUD.show(at: view)
        service.getMyOrderList(index: index) {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            self?.tableData.removeAll()
            if let array = result {
                self?.tableData = array
            }
            self?.tableView.reloadData()
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }
}

extension JMyOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMyOrderTableViewCell
        let order = tableData[indexPath.row]
        cell.nameLabel.text = order.activity?.subTitle
        if order.payStatus == "cancle" {
            cell.statusLabel.text = "已取消"
            cell.statusLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "666666")
            cell.bottomView.isHidden = true
            cell.bottomHeightLConstraint.constant = 0
        } else if order.payStatus == "unpaid" {
            cell.statusLabel.text = "待付款"
            cell.statusLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "FF3B30")
            cell.bottomView.isHidden = false
            cell.bottomHeightLConstraint.constant = 50
        }
        cell.titleLabel.text = "[周四]\(order.activity?.title ?? "")"
        cell.addressLabel.text = "\(order.activity?.province ?? "") \(order.activity?.city ?? "") \(order.activity?.district ?? "")"
        cell.timeLabel.text = order.activity?.startTime
        cell.priceLabel.text = "¥\(order.totalFee ?? 0)"
        cell.numLabel.text = "\(order.people ?? 0)人"
        cell.payLabel.text = "¥\(order.activity?.depositAmount ?? 0)"
        if let url = order.activity?.imageUrl, url.count > 0 {
            cell.iconImageView.kf.setImage(with: URL(string: url))
        } else {
            cell.iconImageView.image = nil
        }
        cell.selectionStyle = .none
        cell.circleButton.isHidden = true
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let order = tableData[indexPath.row]
        orderId = order.id ?? ""
        self.performSegue(withIdentifier: "MyOrderDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}

extension JMyOrderViewController: JMyOrderTableViewCellDelegate {
    
    func payOrder(tag: Int) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JPayActionViewController") as? JPayActionViewController {
            viewController.order = tableData[tag]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func cancelOrder(tag: Int) {
        let order = tableData[tag]
        JHUD.show(at: view)
        service.cancelOrder(orderId: order.id ?? "") {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result {
                self?.getMyOrderList(index: self!.segmentedControl.selectedSegmentIndex)
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }
}
