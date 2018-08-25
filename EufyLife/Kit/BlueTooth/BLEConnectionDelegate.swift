//
//  BLEConnectionDelegate.swift
//  BLEConnection
//
//  Created by Tool Airoha on 2017/7/26.
//  Copyright © 2017年 Tool Airoha. All rights reserved.
//

import Foundation
import CoreBluetooth
/**
 ENUM: BLEConnectResult
 
 success: Connect BLE success
 
 connectFail: Got centralManager didFailToConnect callback
 
 noClassicConnection: There is no classic Bluetooth connection, please connect the BT3.0 first in system page
 
 timeout: connection timeout, cannot find the BLE device
 */
@objc public enum BLEConnectResult: Int {
    case unkown = 0
    case success
    case connectFail
    case timeout
    case connecting
}

/**
 The BLEConnectionDelegate protocol defines the BLE connection result and RSSI value
 */
public protocol BLEConnectionDelegate: NSObjectProtocol {
    /**
     It tells the delegate can start to call connectBLE() API
     */
    func onReadyToConnect()
    /**
     It tells the delegate the result of connectBLE()
     */
    func onBLEConnectFinished(result: BLEConnectResult)
    /**
     It tells the delegate the BLE is disconnected
     */
    func onBLEDisconnected()
    /**
     It tells the delegate the BLE RSSI value
     */
    func onBLERSSIValue(rssi: NSNumber)
    /**
     It tells the delegate the system bt state changed
     */
    func onSystemBTStateChange(state: CBManagerState)
    /**
     Scan BLE Finished
    */
    func onBLEDeviceScanFinished()
    
}
