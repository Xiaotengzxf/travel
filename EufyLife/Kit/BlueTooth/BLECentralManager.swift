//
//  BLECentralManager.swift
//  BLEConnection
//
//  Created by Tool Airoha on 2017/7/26.
//  Copyright © 2017年 Tool Airoha. All rights reserved.
//

import Foundation
import CoreBluetooth
import AVFoundation

class BLECentralManager: NSObject, CBCentralManagerDelegate {
    
    public static let sharedInstance = BLECentralManager()
    private let kMacAddress = "macAddress"
    //member var
    private var _centralManager: CBCentralManager!
    private var toConnectPer : CBPeripheral? = nil
    private var connectedPer : CBPeripheral? = nil
    private var scanTimeoutTimer: Timer?
    private var connectPerTimer: Timer?
    private var reConnectTimer: Timer?
    private var scanMorePerTimer: Timer? // 判读是否扫描出更多设备
    private var createScanTimerCount = 0 // 搜索定时器计数
    private var scanTimeOut: Double = 0
    public var findingMacAddress : String? // 特殊的扫描及连接设备的Mac地址
    public var bleDevices = [CBPeripheral]()
    public var bleDeviceNames : [String: String] = [:]
    public var bleDeviceMacAddress : [String: String] {
        get {
            if let dic = UserDefaults.standard.object(forKey: kMacAddress) as? [String : String] {
                return dic
            }
            return [:]
        }
        set {
            if newValue.count > 0 {
                UserDefaults.standard.set(newValue, forKey: kMacAddress)
            }
        }
    }
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationForForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationForBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    deinit {
        if self.toConnectPer != nil {
            _centralManager.cancelPeripheralConnection(self.toConnectPer!)
            self.toConnectPer = nil
        }
        if self.connectedPer != nil {
            _centralManager.cancelPeripheralConnection(self.connectedPer!)
            self.connectedPer = nil
        }
        invalidateConnectTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationForForeground() {
        if self.scanTimeoutTimer != nil {
            self.scanTimeoutTimer?.fireDate = Date.distantPast
        }
    }
    
    @objc private func applicationForBackground() {
        if self.scanTimeoutTimer != nil {
            self.scanTimeoutTimer?.fireDate = Date.distantFuture
        }
    }
    
    func initCentralManager() {
        if( _centralManager == nil ){
            _centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        }
    }
 
    // CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
            log.info("[BC] Central manager state: not Powered on")
            cleanBLEDeviceConnection()
            BLEConnectionManager.sharedInstance.cbSystemBTStateChange(state: central.state)
            break
        case .poweredOn:
            log.info("[BC] Central manager state: Powered on")
            BLEConnectionManager.sharedInstance.cbSystemBTStateChange(state: .poweredOn)
            let _ = checkBLEConnection()
            break
        }
    }
    
    func cleanBLEDeviceConnection() {
        if self.connectedPer != nil {
            _centralManager.cancelPeripheralConnection(self.connectedPer!)
            self.connectedPer = nil
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != "eufy T9140" {
            return
        }
        if let adv = advertisementData[CBAdvertisementDataManufacturerDataKey] {
            if let data = adv as? Data {
                print("数据: \(data.hexEncodedStringNoBlank())")
                if data.count >= 8 {
                    var macAddress = data.subdata(in: 2..<8).map { String(format: "%02hhx:", $0) }.joined()
                    let end = macAddress.index(macAddress.endIndex, offsetBy: -1)
                    macAddress = String(macAddress[..<end])
                    bleDeviceMacAddress[peripheral.identifier.uuidString] = macAddress
                    if findingMacAddress == macAddress {
                        connectToPeripheral(per: peripheral) // 检测10秒内是否连接成功
                        return
                    }
                }
            }
        }
        if !bleDevices.contains(peripheral) {
            if bleDevices.count == 0 { // 发送通知新发现设备
                createMorePerTimer()
            } else if bleDevices.count == 1 {
                deallocMorePerTimer()
                BLEConnectionManager.sharedInstance.bleDeviceScanFinished()
            } else {
                NotificationCenter.default.post(name: kMultiSelectNotification, object: nil)
            }
            bleDevices.append(peripheral)
        }
        if let localName = advertisementData["kCBAdvDataLocalName"] as? String {
            bleDeviceNames[peripheral.identifier.uuidString] = localName
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScan()
        log.info("[BC] didConnected \(peripheral.name ?? "no name")")
        NotificationCenter.default.post(name: kJHomeViewController, object: false)
        if findingMacAddress != nil {
            cleanBLEDeviceConnection()
        }
        self.toConnectPer = nil // 连接成功后将将连接设备转换成已连接设备
        self.connectedPer = peripheral
        BLEConnectionManager.sharedInstance.cbConnectBLE(result: .success)
        ZFramework.sharedInstance._serviceManager.setPeripheral(peripheral: peripheral)
        ScaleModel.sharedInstance.localName = bleDeviceNames[peripheral.identifier.uuidString] ?? (peripheral.name ?? "")
        invalidateConnectTimer()
        invalidateReconnectTimer()
        findingMacAddress = nil // 清空需要找的设备的Mac地址
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        log.info("[BC] didFailToConnect \(error.debugDescription)")
        BLEConnectionManager.sharedInstance.cbConnectBLE(result: .connectFail)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral.name != nil  {
            log.info("[BC] didDisconnectPeripheral \(peripheral.name!)")
        }
        if connectPerTimer != nil {
            self.connectedPer = nil
            self.connectPerTimer?.invalidate()
            self.connectPerTimer = nil
            sendNotificationToMultiSelect(name: findingMacAddress == nil ? kMultiSelectNotification : kMultiSelectRemoteNotification)
        } else {
            if connectedPer != nil {
                BLEConnectionManager.sharedInstance.cbConnectBLE(result: .unkown)
                BLEConnectionManager.sharedInstance.cbDisconnectedBLE()
                _centralManager.connect(self.connectedPer!, options: nil)
            } else {
                sendNotificationToMultiSelect(name: findingMacAddress == nil ? kMultiSelectNotification : kMultiSelectRemoteNotification)
            }
        }
    }
    
    @objc private func checkReconnect(timer: Timer) {
        NotificationCenter.default.post(name: kJHomeViewController, object: true)
        NotificationCenter.default.post(name: kJRenameViewController, object: nil)
    }
    
    // 断开连接清空资源
    func cleanConnectedPeripheral() {
        self.toConnectPer = nil
        self.connectedPer = nil
        ZFramework.sharedInstance._serviceManager.releasePeripheral()
        BLEConnectionManager.sharedInstance.cbDisconnectedBLE()
    }
    
    // 检查连接是否超时
    @objc private func connectPerCheck(t: Timer) {
        if let per = self.toConnectPer {
            _centralManager.cancelPeripheralConnection(per)
            if findingMacAddress == nil { // 如果不是指定设备连接，就报告连接超时
                BLEConnectionManager.sharedInstance.cbConnectBLE(result: .timeout)
            } else {
                sendNotificationToMultiSelect(name: findingMacAddress == nil ? kMultiSelectNotification : kMultiSelectRemoteNotification)
            }
        }
    }
    
    func stopScan() {
        log.info("[BC] stopScan")
        stopScanTimer()
        _centralManager.stopScan()
    }
    
    // 定时器的执行
    @objc func timeoutToStop() {
        createScanTimerCount += 1
        if createScanTimerCount * 2 < Int(scanTimeOut) {
            if bleDevices.count == 0 {
                _centralManager.stopScan()
                startScanDevcieWithSpecialUUID()
            }
        } else {
            createScanTimerCount = 0
            stopScan()
            if findingMacAddress == nil { // 如果不是指定mac地址连接，则报告扫描结束
                BLEConnectionManager.sharedInstance.bleDeviceScanFinished()
            } else {
                sendNotificationToMultiSelect(name: findingMacAddress == nil ? kMultiSelectNotification : kMultiSelectRemoteNotification)
            }
        }
    }
    
    // 扫描定时器，定时器的时长
    func createScanTimer(timeInternal: Double) {
        if self.scanTimeoutTimer == nil {
            self.stopScanTimer()
            createScanTimerCount = 0
            self.scanTimeoutTimer = Timer.scheduledTimer(timeInterval: timeInternal, target: self, selector: #selector(BLECentralManager.sharedInstance.timeoutToStop), userInfo: nil, repeats: true)
        }
    }
    
    // 停止扫描
    func stopScanTimer() {
        if self.scanTimeoutTimer != nil {
            self.scanTimeoutTimer?.invalidate()
            self.scanTimeoutTimer = nil
        }
    }
    
    // 开始扫描设备，指定超时的时间
    func startScan(timeout: Double) {
        scanTimeOut = timeout
        if _centralManager.state != .poweredOn {
            log.info("[BC] BT POWER is not on")
            return
        }
        stopScan()

        if findingMacAddress != nil || checkBLEConnection() == false {
            startScanDevcieWithSpecialUUID()
            stopScanTimer()
            createScanTimer(timeInternal: 2)
            log.info("[BC] Start scan")
        }
    }
    
    func startScanForever() {
        log.info("[BC] Start scan forever")
        startScanDevcieWithSpecialUUID()
    }
    
    // 检查BLE连接，是否直接尝试连接已连接的设备
    private func checkBLEConnection() -> Bool {
        let value  = tryToConnectedPeripheral()
        if !value {
            NotificationCenter.default.post(name: kBluetoothSettingsNotification, object: kBlueToothScan, userInfo: [kBlueToothScan : true, bWait: false])
        }
        return value
    }
    
    // 尝试连接已经连接的特定蓝牙
    private func tryToConnectedPeripheral() -> Bool {
        return false
    }
    
    // 连接指定的设备，如果有master/slave，默认为master
    func connectToPeripheral(per: CBPeripheral, timeInterval: TimeInterval = 10) {
        BLEConnectionManager.sharedInstance.cbConnectBLE(result: .connecting)
        self.toConnectPer = per
        _centralManager.connect(self.toConnectPer!, options: nil)
        GoogleAnalyticsManager.sharedInstance.trackEvent(category: .app_event, action: .connecting_bluetooth)
        
        if connectPerTimer != nil {
            connectPerTimer?.invalidate()
            connectPerTimer = nil
        }
        
        connectPerTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(connectPerCheck(t:)), userInfo: nil, repeats: false)
        RunLoop.main.add(connectPerTimer!, forMode: .commonModes)
    }
    
    // 发送通知至选择列表，告知失败
    private func sendNotificationToMultiSelect(name: Notification.Name, value: Bool = false) {
        NotificationCenter.default.post(name: name, object: kMultiSelectConnected, userInfo: ["value" : value])
    }
    
    // 清空连接定时器
    private func invalidateConnectTimer() {
        if self.connectPerTimer != nil {
            self.connectPerTimer?.invalidate()
            self.connectPerTimer = nil
        }
    }
    
    // 清空连接定时器
    private func invalidateReconnectTimer() {
        if self.reConnectTimer != nil {
            self.reConnectTimer?.invalidate()
            self.reConnectTimer = nil
        }
    }
    
    func isBLEScaning() -> Bool {
        return _centralManager.isScanning
    }
    
    private func startScanDevcieWithSpecialUUID() {
        let cmdUUID = SupportedService.sharedInstance.getAdvertisingUUID().map{CBUUID(string:  $0)}
        _centralManager.scanForPeripherals(withServices: cmdUUID)
    }
    
    // 当已经扫描到1个设备后，等待1秒，判断是否搜索到更多设备
    private func createMorePerTimer() {
        if scanMorePerTimer == nil {
            scanMorePerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(validateIfHaveMorePer(t:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func validateIfHaveMorePer(t: Timer) {
        deallocMorePerTimer()
        stopScan()
        connectToPeripheral(per: bleDevices[0], timeInterval: 10)
    }
    
    private func deallocMorePerTimer() {
        scanMorePerTimer?.invalidate()
        scanMorePerTimer = nil
    }
    
    // 获取已经连接的设备的macaddress
    public func getConnectedPerMacAddress() -> String? {
        if let uuid = connectedPer?.identifier.uuidString {
            return bleDeviceMacAddress[uuid]
        }
        return nil
    }
}

