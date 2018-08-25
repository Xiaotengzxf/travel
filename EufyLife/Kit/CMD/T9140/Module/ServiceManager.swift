//
//  ServiceManager.swift
//  CMD
//
//  Created by Tool Airoha on 2017/6/19.
//  Copyright © 2017年 AirohaTool. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 The ServiceManagerDelegate protocol defines the peripheral job delegate here.
 */
@objc public protocol ServiceManagerDelegate {
    /**
     A delegate function, tells the delegate there is discovered characteristic, and ready to control Bluetooth devices now
     */
    @objc func didFoundCharacteristic(charList:[CBCharacteristic], discoverAllSupportedService:Bool)
    /**
     A delegate function, tells the delegate the rssi value of the connected peripheral
     
     please also see readRSSI/readRSSIRepeat/stopReadRSSI
     */
    @objc optional func didReadRSSI(rssi: NSNumber, error: Error?)
}

/**
 
 This class include all command function, but do not create instances of this class yourself. Instead, use the ZFramework.sharedInstance._controlModule to retrieve the shared command center object.
 */
@objc public class ServiceManager : NSObject {
    override internal init() {}
    private var readRSSITimer: Timer?
    ///
    /// regNotifyDelegate
    /// register ZFrameworkDelegate delegate
    ///
    @objc public func regServiceManagerModuleDelegate(name:String ,  delegate: ServiceManagerDelegate ) {
        ZFramework.sharedInstance._serviceManagerDelegates[name] = delegate
    }

    ///
    /// setPeripheral
    /// Must set peripheral to framework when BLE connection setup
    /// - parameter peripheral: connected peripheral
    ///
    @objc public func setPeripheral( peripheral: CBPeripheral) {
        BLEPeripheral.sharedInstance.setPeripheral(peripheral)
    }
    
    ///
    /// releasePeripheral
    /// Release peripheral when BLE disconnected
    ///
    @objc public func releasePeripheral() {
        BLEPeripheral.sharedInstance.releasePeripheral()
    }
    
    /**
     Host App can add customize service uuid and characteristic uuid, this API should be invoked before setPeripheral().
     
     Host App can use ZFramework.sharedInstance._controlModule.sendCommand() to execute customer defined command.
     
     The response will callback to didUpdateValueNotDefined delegate function.
     
     - parameter serivceUUIDStr: Please input the service UUID string format like "5052494D-2DAB-0441-6972-6F6861424C45"
     - parameter characteristicUUIDStr: Please input the characteristic UUID string format like "5052494D-2DAB-0441-6972-6F6861424C45"
     */
    @objc public func addCustomizeServiceAndChar(serivceUUIDStr: String, characteristicUUIDStr: String) {
        SupportedService.sharedInstance.addSupportServiceAndCharacteristic(serviceUUID: serivceUUIDStr, charUUID: characteristicUUIDStr)
    }
    
    
    func didDiscoverCharacteristic(charList:[CBCharacteristic], discoverAllSupportedService:Bool) {
        for delegate in ZFramework.sharedInstance._serviceManagerDelegates {
            delegate.1.didFoundCharacteristic(charList: charList, discoverAllSupportedService: discoverAllSupportedService)
        }
    }
    
    func didReadRSSI(rssi: NSNumber, error: Error?) {
        for delegate in ZFramework.sharedInstance._serviceManagerDelegates {
            delegate.1.didReadRSSI?(rssi: rssi, error: error)
        }
    }
    
    ///
    /// get discovered characteristics list
    ///
    @objc public func getCharList() -> [CBCharacteristic]{
        return BLEPeripheral.sharedInstance.getCharList()
    }
    
    /**
     Read rssi value of the connected peripheral, and the didReadRSSI delegate function will give you result
     */
    @objc public func readRSSI() {
        BLEPeripheral.sharedInstance.readRSSI()
    }
    
    /**
     Read rssi value of the connected peripheral repeatedly, and the didReadRSSI delegate function will give you result
     */
    @objc public func readRSSIRepeat() {
        if readRSSITimer != nil {
            readRSSITimer?.invalidate()
            readRSSITimer = nil
        }
        
        DispatchQueue.main.async {
            self.readRSSITimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BLEPeripheral.sharedInstance.readRSSI), userInfo: nil, repeats: true)
        }
    }
    
    /**
     Stop readRSSIRepeat action
     */
    @objc public func stopReadRSSI() {
        if readRSSITimer != nil {
            readRSSITimer?.invalidate()
            readRSSITimer = nil
        }
    }
}
