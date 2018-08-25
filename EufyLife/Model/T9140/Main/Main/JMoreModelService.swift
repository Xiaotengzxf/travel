//
//  JMoreModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMoreModelService: NSObject {
    
    private weak var presenter: JMorePresenterDelegate?
    private var childLockTemp : Bool?
    
    init(presenter: JMorePresenterDelegate) {
        super.init()
        self.presenter = presenter
        
    }
    
    deinit {
    }
    
    // MARK: - Private
    
    private func startKVO() {
    }
    
    private func endKVO()  {
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kMoreNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification
    
    @objc private func handleNotification(notification: Notification) {
        
    }
    
    // MARK: - KVC
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
}

extension JMoreModelService: JMoreModelServiceDelegate {
    
    func getLocalName() -> String {
        return ScaleModel.sharedInstance.localName
    }
    
    func getChildLockStatus() -> Bool {
        return false
    }
    
    func setChildLockStatus(value: Bool) {
        
    }
    
    func disconnect() {
       
    }
    
    func getNeedUpdate() -> Bool {
        return false
    }
    
}
