//
//  SCMultiSelectModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/1/10.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCMultiSelectModelService: NSObject {
    
    private weak var presenter: JMultiSelectDelegate?
    let connectionStateKeyPath = "connectionState"
    var nameArray: [String] = []
    var connectCount = 0
    
    init(presenter: JMultiSelectDelegate) {
        super.init()
        self.presenter = presenter
        startKVO()
        registerNotification()
    }
    
    deinit {
        endKVO()
        removeNotification()
    }
    
    func startKVO() {
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: connectionStateKeyPath, options: .new, context: nil)
    }
    
    func endKVO() {
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: connectionStateKeyPath)
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kMultiSelectNotification, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: kMultiSelectNotification, object: nil)
    }
    
    @objc func handleNotification(notification: Notification) {
        if let object = notification.object as? String {
            
        } else {
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == connectionStateKeyPath {
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension SCMultiSelectModelService: JMultiSelectDelegate {
    func getDeviceListCount() -> Int {
        return BLECentralManager.sharedInstance.bleDevices.count
    }
    
    func getDeviceName() -> [String] {
        nameArray.removeAll()
        nameArray = BLECentralManager.sharedInstance.bleDevices.map{
            if let name = BLECentralManager.sharedInstance.bleDeviceNames[$0.identifier.uuidString], name.count > 0 {
                return name
            }
            return $0.name ?? ""
        }
        return nameArray
    }
    
}
