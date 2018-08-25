//
//  JBluetoothSettingViewDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

protocol JBluetoothSettingViewDelegate: NSObjectProtocol {
    func showBluetoothPowerOff(isOn: Bool)
    func handleCanCommand(_ isValue: Bool)
    
    func callbackFinishedToScanDevice(_ bResult: Bool)
    
    /// 回调蓝牙扫描
    func callbackBlueToothScan(bWait: Bool)
    
    /// 回调握手
    func callbackForHandShakeFail()
    func callbackGetDeviceInfo(result: Bool?)
    
    func callbackForConnectFailThreeTime()
}
