//
//  Model.swift
//  Import152xFramework_Swift
//
//  Created by Tool Airoha on 2017/1/9.
//  Copyright © 2017年 Tool Airoha. All rights reserved.
//

import Foundation

@objcMembers class ScaleModel: NSObject {
    
    static let sharedInstance = ScaleModel()
    
    dynamic var readySetCommand = false
    dynamic var localName = "" // 设备名称
    dynamic var connectionState : BLEConnectResult = .unkown // 蓝牙连接状态
    dynamic var bluetoothStatePoweredOn = false // 蓝牙当前状态
    
    var index = 0
    
    
}

