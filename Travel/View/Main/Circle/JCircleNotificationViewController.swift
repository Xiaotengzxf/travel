//
//  JCircleNotificationViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JCircleNotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let service = JCircleNotificationModelService()
    private var tableData: [CircleNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        JHUD.show(at: view)
        service.circleNotificationList {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result != nil {
                self?.tableData = result!
                self?.tableView.reloadData()
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JCircleNotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JCircleNotificationTableViewCell
        cell.delegate = self
        let notification = tableData[indexPath.row]
        if let icon = notification.user?.icon, icon.hasPrefix("http") {
            cell.iconImageView.kf.setImage(with: URL(string: icon))
        } else {
            cell.iconImageView.image = UIImage(named: "icon_2")
        }
        if notification.user?.type == "agree" {
            cell.statusLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7")
            cell.statusLabel.text = "已同意"
        } else {
            cell.statusLabel.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "999999")
            cell.statusLabel.text = "已拒绝"
        }
        cell.titleLabel.text = notification.user?.userName
        cell.descLabel.text = notification.user?.introduce
        cell.showButton(value: true)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let notification = tableData[indexPath.row]
        if (notification.user?.type?.count ?? 0) > 0 {
            return 86
        } else {
            return 119
        }
        
    }
    
}

extension JCircleNotificationViewController: JCircleNotificationTableViewCellDelegate {
    func agree(tag: Int) {
        
    }
    
    func reject(tag: Int) {
        
    }
}
