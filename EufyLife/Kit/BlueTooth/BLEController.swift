//
//  BLEController
//  BluetoothVoiceAssistant
//
//  Created by Tool Airoha on 2017/7/28.
//  Copyright © 2017年 Tool Airoha. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEController: NSObject {
    
    static let sharedInstance = BLEController()

    func registerBLEManager() {
        BLEConnectionManager.sharedInstance.registerBLEConnectionListener(name: "BackgroundManager", delegate: self)
    }
    
    func onReadyToConnect() {
        log.info("[BVA] got onReadyToConnect")
        BLEConnectionManager.sharedInstance.connectBLE(timeout: 10)
    }
}

extension BLEController: BLEConnectionDelegate {
    
    func onBLEConnectFinished(result: BLEConnectResult) {
        ScaleModel.sharedInstance.connectionState = result
        if result != .connectFail && result != .timeout {
            //ScaleModel.sharedInstance.bleDevices = []
        }
    }
    
    func onBLEDisconnected() {
        log.info("[BVA] Disconnected BLE")
        ScaleModel.sharedInstance.readySetCommand = false
    }
    
    func onBLERSSIValue(rssi: NSNumber) {
        log.info("[BVA] onBLERSSIValue \(rssi.intValue)")
    }
    
    func onSystemBTStateChange(state: CBManagerState) {
        ScaleModel.sharedInstance.bluetoothStatePoweredOn = state == .poweredOn
        if state == .poweredOff {
            ScaleModel.sharedInstance.readySetCommand = false
        }
    }
    
    func onBLEDeviceScanFinished() {
        if ScaleModel.sharedInstance.readySetCommand == false {
            NotificationCenter.default.post(name: kBluetoothSettingsNotification, object: nil, userInfo: [kScanFinished: true])
        }
    }
}

