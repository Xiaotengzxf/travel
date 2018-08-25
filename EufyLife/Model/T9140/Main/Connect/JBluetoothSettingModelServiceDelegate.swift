//
//  JBluetoothSettingModelServiceDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

protocol JBluetoothSettingModelServiceDelegate: NSObjectProtocol {
    
    /// 获取蓝牙状态
    ///
    /// - Returns: 是否
    func getBluetoothState() -> Bool
    
    func isOTAUpdateFinished() -> Bool
    
    func isBLEScaning() -> Bool
    
    /// 开始扫描设备
    ///
    /// - Returns: 无
    func startScanDevice()
    
    /// 名称是否修改过
    ///
    /// - Returns: 是否
    func isChangedForLocalName() -> Bool
    
    /// 发送握手指令
    func handShake()
    
    func disconnectToConnectedDevice()
}
