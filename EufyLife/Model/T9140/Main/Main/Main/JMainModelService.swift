//
//  SCMainModelService.swift
//  Jouz
//
//  Created by ANKER on 2017/12/26.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import AVFoundation

class JMainModelService: NSObject {
    
    private weak var presenter: JMainCallbackDelegate?
    let bluetoothStateKeyPath = "bluetoothStatePoweredOn"
    let connectionStateKeyPath = "connectionState"
    let readySetCommandKeyPath = "readySetCommand"

    init(presenter: JMainCallbackDelegate) {
        super.init()
        self.presenter = presenter
        registerNotification()
        startKVO()
        if JUserManager.sharedInstance.deivces.count > 0 {
            BLEController.sharedInstance.registerBLEManager()
        }
        if ScaleModel.sharedInstance.readySetCommand {
            synchronizeTimeToBLE()
        }
    }
    
    deinit {
        removeNotification()
        endKVO()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func startKVO() {
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: bluetoothStateKeyPath, options: .new, context: nil)
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: connectionStateKeyPath, options: .new, context: nil)
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: readySetCommandKeyPath, options: .new, context: nil)
    }
    
    private func endKVO() {
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: bluetoothStateKeyPath)
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: connectionStateKeyPath)
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: readySetCommandKeyPath)
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kMainNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 记录用户的选择 TODO: - 后期需要修改扩展
    private func recordApplicationIndex() {
        
    }
    
    private func saveBoundDeviceDataToDB() {
        
    }
    
    // 向服务器传输绑定设备
    private func bindDevice() {
        
    }
    
    private func synchronizeTimeToBLE() {
        print("同步时间")
        let date = Date().timeIntervalSince1970
        let data = Utility.sharedInstance.IntToNSData(data: Int(date), length: 4)
        ZFramework.sharedInstance._controlModule.addCmdToQueue(cmd: T9140CMD.syncLoalTime.rawValue, param: data)
    }
    
    private func synchronizeScaleUnitToBLE() {
        print("同步单位")
        let data = Data(bytes: [0x00, 0x00])
        ZFramework.sharedInstance._controlModule.addCmdToQueue(cmd: T9140CMD.setScaleUint.rawValue, param: data)
    }
    
    private func getScaleHistoryData() {
        print("历史数据")
        let data = Data(bytes: [0x00, 0x00])
        ZFramework.sharedInstance._controlModule.addCmdToQueue(cmd: T9140CMD.getHistoryData.rawValue, param: data)
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == bluetoothStateKeyPath {
            if ScaleModel.sharedInstance.bluetoothStatePoweredOn {
                if JUserManager.sharedInstance.deivces.count > 0 {
                    if let macAddress = JUserManager.sharedInstance.deivces[0].bluetooth?.ble_mac {
                        BLECentralManager.sharedInstance.findingMacAddress = macAddress
                        BLEConnectionManager.sharedInstance.connectBLE(timeout: 0)
                    }
                }
            }
        } else if keyPath == connectionStateKeyPath {
            var state = ""
            switch ScaleModel.sharedInstance.connectionState {
            case .connecting:
                state = "Connecting"
            case .success:
                state = "Connected"
            default:
                state = "Disconnecting"
            }
            presenter?.callbackConnectState(state: state)
        } else if keyPath == readySetCommandKeyPath {
            if ScaleModel.sharedInstance.readySetCommand {
                synchronizeTimeToBLE()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Notification
    
    @objc func handleNotification(notification: Notification) {
        if let raw = notification.object as? Int {
            if raw == T9140CMD.syncLoalTime.rawValue {
                if let userInfo = notification.userInfo as? [String: Bool] {
                    if let result = userInfo[kValue], result {
                        synchronizeScaleUnitToBLE()
                    }
                } else {
                    
                }
            } else if raw == T9140CMD.setScaleUint.rawValue {
                if let userInfo = notification.userInfo as? [String: Bool] {
                    if let result = userInfo[kValue], result {
                        getScaleHistoryData()
                    }
                } else {
                    
                }
            } else if raw == T9140CMD.currentData.rawValue {
                if let userInfo = notification.userInfo as? [String: Any] {
                    let weight = userInfo["weight"] as? Int ?? 0
                    presenter?.callbackScaleData(weight: "\(Double(weight) / 10.0)")
                }
            } else if raw == Int.max {
                synchronizeTimeToBLE()
            }
        }
    }
}

extension JMainModelService: JMainDelegate {
    
    func getBackgroundImages() -> [UIImage] {
        let arrTop = ["00D6C9", "4DD0BA", "56D4BB", "64D8D0"]
        let arrBottom = ["00D4DD", "D37FBE", "D2D985", "90A4F0"]
        let size = CGSize(width: screenWidth, height: screenHeight)
        var arrImage : [UIImage] = []
        for i in 0..<4 {
            let colors = [ZColorManager.sharedInstance.colorWithHexString(hex: arrTop[i]), ZColorManager.sharedInstance.colorWithHexString(hex: arrBottom[i])]
            let image = UIImage.gradientColorImage(size, gradientColors: colors, vertical: true)
            arrImage.append(image)
        }
        return arrImage
    }
    
    func getDeviceCount() -> Int {
        return JUserManager.sharedInstance.deivces.count
    }
    
    func getCurrentMemberName() -> String {
        return JUserManager.sharedInstance.members.first?.name ?? ""
    }
    
    func getDeviceInfoes() -> [Device] {
        return JUserManager.sharedInstance.deivces
    }
    
    func getMemberCount() -> Int {
        return JUserManager.sharedInstance.members.count
    }
    
    func getMemberInfo(row: Int) -> Customer {
        return JUserManager.sharedInstance.members[row]
    }
}
