//
//  JSideMenuModelService.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSideMenuModelService: NSObject {
    private let arrayIconName = ["sidememu_icon_fitbit",
                                 "setting_icon_apple",
                                 "sidemenu_icon_help",
                                 "setting_icon_privacy",
                                 "sidemune_icon_password"]
    private let arrayTitle = ["Connect to Fitbit",
                              "Connect to Apple Health",
                              "Help",
                              "Privacy",
                              "Change password"]
    private weak var presenter: JSideMenuCallbackDelegate?
    
    init(presenter: JSideMenuCallbackDelegate) {
        super.init()
        self.presenter = presenter
        registerNotification()
    }
    
    deinit {
        removeNotifcation()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kJSideMenuModelServiceNotification, object: nil)
    }
    
    private func removeNotifcation() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification
    
    @objc func handleNotification(notification: Notification) {
        if let obj = notification.object as? String {
            if obj == kA {
                presenter?.callbackForRefreshMember()
            } else if obj == kB {
                presenter?.callbackForRefreshUserInfo()
            }
        }
    }

}

extension JSideMenuModelService: JSideMenuDelegate {
    func getTableViewCellData(row: Int) -> (String, String) {
        return (arrayTitle[row], arrayIconName[row])
    }
    
    func getTableViewCellNum() -> Int {
        return arrayTitle.count
    }
    
    func getEmail() -> String {
        return UserDefaults.standard.object(forKey: kEmail) as? String ?? ""
    }
    func getMemberCount() -> Int {
        return JUserManager.sharedInstance.members.count - 1
    }
    
    func getMemberInfo(row: Int) -> Customer {
        return JUserManager.sharedInstance.members[row + 1]
    }
    
    func getUserInfo() -> String {
        let member = JUserManager.sharedInstance.members[0]
        let date = Date(timeIntervalSince1970: TimeInterval(member.birthday))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let d1 = dateFormatter.string(from: Date())
        let d2 = dateFormatter.string(from: date)
        let year1 = Int(d1.components(separatedBy: "-").first ?? "0") ?? 0
        let year2 = Int(d2.components(separatedBy: "-").first ?? "0") ?? 0
        return "\(member.sex ?? ""), \(year1 - year2) years old, \(member.height)cm"
    }
    
}
