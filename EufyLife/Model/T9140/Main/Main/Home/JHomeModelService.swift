//
//  JHomeModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHomeModelService: NSObject {
    
    private weak var presenter: JHomeDelegate?
    
    init(presenter: JHomeDelegate) {
        super.init()
        self.presenter = presenter
        registerNotification()
    }
    
    deinit {
        removeNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kHomeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: kHomeNotification, object: nil)
    }
    
    @objc func handleNotification(notification: Notification) {
        
    }
}

extension JHomeModelService: JHomeDelegate {
    
    func getMemberCount() -> Int {
        return JUserManager.sharedInstance.members.count
    }
}
