//
//  ZFrameworkDelegate.swift
//  ZFramework
//
//  Created by AirohaTool on 2016/9/20.
//  Copyright © 2016年 AirohaTool. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 A static, singleton class and including four sub modules: ControlModule, ServiceManager, OTAModule and ANCSModule. Please do not create instances by yourself. Instead, use the ZFramework.Inst to do all you want to do. And implement the four delegates in your APP to listen response from our framework.
 
 
    The step of using ZFramework remote control BT chip roughly like below:
 
    1. ZFramework.sharedInstance._controlModule.initControlModuleProxy()
 
    2. Create a class to implement ControlMdouleDelegate protocol in UI App
 
    3. ZFramework.sharedInstance._controlModule.regControlModuleDelegate()
 
    4. Create a class to implement ServiceMaangerDelegate protocol in UI App
 
    5. ZFramework.sharedInstance._serviceManager.setPeripheral() when BLE is connected
 

 
    Then, you can call specific command that you want to do, like:
 
    ZFramework.sharedInstance._controlModule.getBattery()
 
    And the result will delegte to the class that you implement the ControlModuleDelegate and ServiceManagerDelegate protocol
 
 */

public class ZFramework: NSObject {
    /**
     A shared, singleton instance, any operation must using this instance
     */
    public static let sharedInstance = ZFramework()
    var _serviceManagerDelegates = [String: ServiceManagerDelegate]()
    var _controlModuleDelegates = [String: ControlModuleDelegate]()
    
    /**
     A instance of ServiceManager class, all of peripheral job is included in this instance
     */
    public let _serviceManager = ServiceManager()
    
    /**
     A instance of ControlModule class, all of commands are included in this instance
     */
    public let _controlModule = ControlModule()
    
}


