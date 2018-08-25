//
//  SCBluetoothSettingsPresenter.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class JBluetoothSettingPresenter: NSObject {
    
    weak var viewDelegate: JBluetoothSettingViewDelegate?
    var modelService: JBluetoothSettingModelServiceDelegate?
    
    init(delegate: JBluetoothSettingViewDelegate) {
        super.init()
        viewDelegate = delegate
        modelService = JBluetoothSettingModelService(presenter: self)
    }
    
}

extension JBluetoothSettingPresenter: JBluetoothSettingPresenterDelegate {
    
    func showBluetoothPowerOff(isOn: Bool) {
        viewDelegate?.showBluetoothPowerOff(isOn: isOn)
    }
    
    func handleCanCommand(_ isValue: Bool) {
        viewDelegate?.handleCanCommand(isValue)
    }
    
    func getBluetoothState() -> Bool {
        return modelService?.getBluetoothState() ?? false
    }
    
    func startScanDevice() {
        modelService?.startScanDevice()
    }
    
    func isOTAUpdateFinished() -> Bool {
        return modelService?.isOTAUpdateFinished() ?? false
    }
    
    func isChangedForLocalName() -> Bool {
        return modelService?.isChangedForLocalName() ?? false
    }
    
    func handShake() {
        modelService?.handShake()
    }
    
    func disconnectToConnectedDevice() {
        modelService?.disconnectToConnectedDevice()
    }
    
    func callbackFinishedToScanDevice(_ bResult: Bool) {
        viewDelegate?.callbackFinishedToScanDevice(bResult)
    }
    
    func callbackBlueToothScan(bWait: Bool) {
        viewDelegate?.callbackBlueToothScan(bWait: bWait)
    }
    
    func callbackForHandShakeFail() {
        viewDelegate?.callbackForHandShakeFail()
    }
    
    func callbackGetDeviceInfo(result: Bool?) {
        viewDelegate?.callbackGetDeviceInfo(result: result)
    }
    
    func callbackForConnectFailThreeTime() {
        viewDelegate?.callbackForConnectFailThreeTime()
    }
    
    func isBLEScaning() -> Bool {
        return modelService?.isBLEScaning() ?? false
    }
}
