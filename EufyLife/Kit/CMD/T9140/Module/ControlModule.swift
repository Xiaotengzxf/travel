//
//  ControlModule.swift
//  CMD
//
//  Created by Tool Airoha on 2017/6/19.
//  Copyright © 2017年 AirohaTool. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 The ControlModuleDelegate protocol defines the communication method for command state updates from ZFramework to their delegates.
 
 
 The step of using ControlModule control BT chip roughly like below:
 
 1. ZFramework.sharedInstance._controlModule.initControlModuleProxy()
 
 2. Create a class to implement ControlMdouleDelegate protocol in UI App
 
 3. ZFramework.sharedInstance._controlModule.regControlModuleDelegate()
 
 4. Create a class to implement ServiceMaangerDelegate protocol in UI App
 
 5. ZFramework.sharedInstance._serviceManager.setPeripheral() when BLE is connected
 
 
 
 Then, you can call specific command that you want to do, like:
 
 ZFramework.sharedInstance._controlModule.getBattery()
 
 And the result will delegte to the class that you implement the ControlModuleDelegate and ServiceManagerDelegate protocol
 
 */
@objc public protocol ControlModuleDelegate {
    ///
    /// singleCmdResp
    /// Tells the delegate got a command response
    /// and according to cmdType user can deal with different return value
    ///
    @objc func singleCmdResp(cmdType: Int, didReturnValue: Data?, error:NSNumber?)
    ///
    /// didUpdateValueNotDefined
    /// Tells the delegate there is a response was not defined by airoha framework
    ///
    @objc func didUpdateValueNotDefined(characteristic:CBCharacteristic)
    
}

/**
 
 This class include all command function, but do not create instances of this class yourself. Instead, use the ZFramework.sharedInstance._controlModule to retrieve the shared command center object.
 */
@objc public class ControlModule : NSObject {
    
    private let proxy = CMDProxy()
    
    ///
    /// initCMDProxy
    /// Set up command proxy, must invoke this function when app launch first time
    @objc public func initControlModuleProxy() {
        proxy.initCmdPorxy()
    }
    ///
    /// regNotifyDelegate
    /// register ZFrameworkDelegate delegate
    ///
    @objc public func regControlModuleDelegate(name:String ,  delegate: ControlModuleDelegate ) {
        ZFramework.sharedInstance._controlModuleDelegates[name] = delegate
    }
    ///
    /// unregister ZFrameworkDelegate delegate
    ///
    @objc public func unRegNotifyDelegate(name:String) {
        ZFramework.sharedInstance._controlModuleDelegates.removeValue(forKey: name)
    }
    
    func AirohaSingleCmd(cmdType: Int, didReturnValue: Data?, error: NSNumber?) {
        for delegate in ZFramework.sharedInstance._controlModuleDelegates {
            delegate.1.singleCmdResp(cmdType: cmdType, didReturnValue: didReturnValue, error: error)
        }
    }
    
    func AirohaNotDefinedResp(characteristic:CBCharacteristic) {
        for delegate in ZFramework.sharedInstance._controlModuleDelegates {
            delegate.1.didUpdateValueNotDefined(characteristic: characteristic)
        }
    }
    
    /**
     addCmdToQueue - Add a command to a queue which will execute command one by one.
     - parameter cmd
     - parameter param: Different command should take different type parameter
     
     Other commands take the parameter with nil.
     */
    @objc public func addCmdToQueue(cmd: Int, param: Data?, toQueue: Bool = true) {
        let uuid = SupportedService.sharedInstance.writeCharacteristicUUID
        if lockCenter.sharedInstance.preRunCheck(cmdItem: cmd, funcName: #function, writeUUID: uuid) != 0 {
            return
        }
        CMDQueue.sharedInstance.AddCmdQueue(cmd: cmd, param: param, toQueue: toQueue)
    }
    
}

