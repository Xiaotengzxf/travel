//
//  JBluetoothSettingPresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

protocol JBluetoothSettingPresenterDelegate: NSObjectProtocol {
    func showBluetoothPowerOff(isOn: Bool)
    func handleCanCommand(_ isValue: Bool)
    func getBluetoothState() -> Bool
    func startScanDevice()
    func isOTAUpdateFinished() -> Bool
    func isChangedForLocalName() -> Bool
    func disconnectToConnectedDevice()
    func isBLEScaning() -> Bool
    /// 发送握手指令
    func handShake()
    
    func callbackFinishedToScanDevice(_ bResult: Bool)
    func callbackBlueToothScan(bWait: Bool)
    func callbackForHandShakeFail()
    func callbackForConnectFailThreeTime()
    func callbackGetDeviceInfo(result: Bool?)
}
