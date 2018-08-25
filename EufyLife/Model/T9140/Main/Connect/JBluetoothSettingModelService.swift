//
//  JBluetoothSettingModelService.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

class JBluetoothSettingModelService: NSObject {
    
    weak var presenter : JBluetoothSettingPresenterDelegate?
    let bluetoothStateKeyPath = "bluetoothStatePoweredOn"
    let readySetCommandKeyPath = "readySetCommand"
    private var count = 0 // 读取设备信息计数
    private var callbackCount = 0 // 固件端回调计数
    private var dicDeviceData: [String: UInt32] = [:]
    
    init(presenter: JBluetoothSettingPresenterDelegate) {
        super.init()
        self.presenter = presenter
        startKVO()
        registerNotification()
        DispatchQueue.once(token: "checkIfNeedShowWelcome") {
            checkIfNeedShowWelcome()
        }
        if JUserManager.sharedInstance.deivces.count == 0 {
            BLEController.sharedInstance.registerBLEManager()
        }
    }
    
    deinit {
        presenter = nil
        endKVO()
        removeNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kBluetoothSettingsNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: kBluetoothSettingsNotification, object: nil)
    }
    
    private func startKVO() {
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: bluetoothStateKeyPath, options: .new, context: nil)
        ScaleModel.sharedInstance.addObserver(self, forKeyPath: readySetCommandKeyPath, options: .new, context: nil)
    }
    
    private func endKVO() {
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: bluetoothStateKeyPath)
        ScaleModel.sharedInstance.removeObserver(self, forKeyPath: readySetCommandKeyPath)
    }
    
    private func getConnectedDeivceAllInfo() {
        
    }
    
    private func bindConnectedDevice() {
        if let macAddress = BLECentralManager.sharedInstance.getConnectedPerMacAddress() {
            bindDevices(macs: [macAddress])
        }
    }
    
    private func bindDevices(macs: [String]) {
        let request = JBindDeviceRequestModel(macAddress: macs)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (response, error) in
            if let data = response?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let model = try? JSONDecoder().decode(JBindDeviceResponseModel.self, from: data)
                print("\(model?.res_code)")
            }
        }
    }
    
    private func checkIfNeedShowWelcome() {
        let requestModel = SCWelcomeRequestModel()
        let network = ZNetwork()
        network.request(strUrl: requestModel.url(), strMethod: "GET", parameters: nil, headers: requestModel.toHeader()) { (strResponse, error) in
            if let response = strResponse?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let responseModel = try? JSONDecoder().decode(SCWelcomeResponseModel.self, from: response)
                let time = responseModel?.data_policy_time ?? 0
                let bUpdate = responseModel?.data_policy_updated ?? false
                if bUpdate {
                    UserDefaults.standard.set(false, forKey: kWelcomeKey)
                }
                if time > 0 {
                    UserDefaults.standard.set(time, forKey: kPolicyKey)
                }
            }
        }
    }
    
    @objc func handleNotification(notification: Notification) {
        if let obj = notification.object as? String {
            if obj == kBlueToothScan {
                if let userinfo = notification.userInfo as? [String: Bool] {
                    let _ = userinfo[kBlueToothScan] ?? false
                    presenter?.callbackBlueToothScan(bWait: userinfo[bWait] ?? false)
                }
            } else if obj == kConnectFailThreeTime {
                presenter?.callbackForConnectFailThreeTime()
            }
        } else if let obj = notification.object as? Int {
            
            
            
        }  else {
            if let userinfo = notification.userInfo as? [String: Bool] {
                let scanFinished = userinfo[kScanFinished] ?? false
                if scanFinished {
                    let scanResult = BLECentralManager.sharedInstance.bleDevices.count >= 1
                    presenter?.callbackFinishedToScanDevice(scanResult)
                }
            }else{ // TODO: - 主页读取失败
                presenter?.callbackFinishedToScanDevice(false)
            }
        }
    }
    
    private func addDeviceCacheData() {
        
    }
    
    private func uploadDeviceSmokeCacheData(array: [Any]) {
        
    }
    
    // KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == bluetoothStateKeyPath {
            presenter?.showBluetoothPowerOff(isOn: ScaleModel.sharedInstance.bluetoothStatePoweredOn)
        }else if keyPath == readySetCommandKeyPath {
            presenter?.handleCanCommand(ScaleModel.sharedInstance.readySetCommand)
            if ScaleModel.sharedInstance.readySetCommand {
                bindConnectedDevice()
                NotificationCenter.default.post(name: kMainNotification, object: Int.max)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // TODO: - 读取固件缓存数据
    private func readServerData() {
        
    }
    
    @objc private func scanDevice() {
        BLEConnectionManager.sharedInstance.cbReadyToConnect()
    }
}

extension JBluetoothSettingModelService: JBluetoothSettingModelServiceDelegate {
    
    func getBluetoothState() -> Bool {
        return ScaleModel.sharedInstance.bluetoothStatePoweredOn
    }
    
    func startScanDevice() {
        scanDevice()
    }
    
    func isOTAUpdateFinished() -> Bool {
        return false
    }
    
    func isChangedForLocalName() -> Bool {
        let bIsChangendDeviceName = ["jouz_0002", "jouz 20s", "jouz 12s"].contains(ScaleModel.sharedInstance.localName)
        return !bIsChangendDeviceName
    }
    
    func handShake() {
        //ZFramework.sharedInstance._controlModule.addCmdToQueue(cmd: T9140CMD.handShake.rawValue, param: nil)
    }
    
    func disconnectToConnectedDevice() {
        BLEConnectionManager.sharedInstance.disconnectBLE()
    }
    
    func isBLEScaning() -> Bool {
        return ScaleModel.sharedInstance.readySetCommand == false && !BLECentralManager.sharedInstance.isBLEScaning()
    }
}
