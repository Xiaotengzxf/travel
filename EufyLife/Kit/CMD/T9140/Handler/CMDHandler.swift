//
//  CMDHandler.swift
//  Import152xFramework_Swift
//
//  Created by Tool Airoha on 2017/1/9.
//  Copyright © 2017年 Tool Airoha. All rights reserved.
//

import Foundation
import CoreBluetooth

enum CMDErrorCode: Int {
    case normal = 0
    case timeout = -1
    case nowritepermission = -2
    case noperipheral = -3
    case parametererror = -4
    case readerror = -5
}

class CMDHandler: NSObject {
    
    static let sharedInstance = CMDHandler()
    
    func registerCmdNotify() {
        ZFramework.sharedInstance._controlModule.regControlModuleDelegate(name: "CMDHandler", delegate: self)
        ZFramework.sharedInstance._serviceManager.regServiceManagerModuleDelegate(name: "CMDHandler", delegate: self)
        ZFramework.sharedInstance._controlModule.initControlModuleProxy()
        JCMDManager.sharedInstance.initialCMDs(cmds: T9140CMD.cmd())
    }
    
    private func handleCMDTimeout(cmdType: Int) {
        if let cmd = T9140CMD(rawValue: cmdType) {
            switch cmd {
            case .syncLoalTime, .setScaleUint:
                NotificationCenter.default.post(name: kMainNotification, object: cmdType, userInfo: nil)
            default:
                print("TODO time out")
            }
        }
        
    }
    
    private func handleCMD(cmdType: Int, data: Data?) {
        if let cmd = T9140CMD(rawValue: cmdType) {
            switch cmd {
            case .syncLoalTime:
                if let d = data, d.count == 1 {
                    NotificationCenter.default.post(name: kMainNotification, object: cmdType, userInfo: [kValue: d[0] == 0x07])
                }
            case .setScaleUint:
                if let d = data, d.count == 1 {
                    NotificationCenter.default.post(name: kMainNotification, object: cmdType, userInfo: [kValue: d[0] == 0xfe])
                }
            case .currentData:
                if let d = data, d.count == 5 {
                    let weight = Utility.sharedInstance.NSDataToInt(data: Data(d.subdata(in: 0..<2).reversed()))
                    print("获取的重量数据为：\(weight)")
                    var value = false
                    if d[4] == 0xca {
                        value = true
                    }
                    NotificationCenter.default.post(name: kMainNotification, object: cmdType, userInfo: [kValue: value, "weight" : weight])
                }
            default:
                print("TODO")
            }
        }
    }
    
    private func handleCmdDataToInt(data: Data?, location: Int = 0, length: Int = 1) -> Int {
        if let valueData = data {
            var value = 0
            (valueData as NSData).getBytes(&value, range: NSRange(location: location, length: length))
            return value
        }
        return 0
    }
    
    private func handleCmdDataToBool(data: Data?) -> Bool {
        if let valueData = data {
            var value = 0
            (valueData as NSData).getBytes(&value, range: NSRange(location: 0, length: 1))
            return value > 0
        }
        return false
    }
    
    private func handleCmdDataToTupleBool(data: Data?) -> (Bool, Bool) {
        if let valueData = data {
            var value = 0
            (valueData as NSData).getBytes(&value, range: NSRange(location: 0, length: 1))
            var value2 = 0
            (valueData as NSData).getBytes(&value2, range: NSRange(location: valueData.count - 1, length: 1))
            return (value > 0, value2 > 0)
        }
        return (false, false)
    }
    
    private func handleCmdDataToBool(cmd: T9140CMD, data: Data?, notificationName: Notification.Name) {
        if let valueData = data {
            var bValue = 0
            (valueData as NSData).getBytes(&bValue, range: NSRange(location: valueData.count - 1, length: 1))
            NotificationCenter.default.post(name: notificationName, object: cmd.rawValue, userInfo: ["value": bValue > 0])
        }
    }
}

extension CMDHandler: ControlModuleDelegate {
    /* ErrorCode: Int type, 1-255 return from command response
     -1 : command timeout
     -2 : can not find the write characteristic of airoha command
     -3 : peripheral not found, make sure setPeripheral() have been invoked and still connected
     -4 : parameter taken error*/
    
    func singleCmdResp(cmdType: Int, didReturnValue: Data?, error: NSNumber?) {
        if let err = error {
            
            var message = "\(cmdType)"
            if err.intValue == ErrorCode.timeout() {
                // TODO: -超时处理
                handleCMDTimeout(cmdType: cmdType)
            } else if err.intValue == ErrorCode.writeCharacteristicNotFound() {
                message.append("Write Characteristic Not Found")
            } else {
                message.append("Cmd status - \(err.intValue)")
            }
            log.debug("BLE CALLBACK: \(message)")
            return
        }
        // TODO: -指令处理
        handleCMD(cmdType: cmdType, data: didReturnValue)
    }
    
    func didUpdateValueNotDefined(characteristic: CBCharacteristic){
        log.info("[didUpdateValueNotDefined] \(characteristic)")
    }
}

extension CMDHandler: ServiceManagerDelegate {
    
    func didFoundCharacteristic(charList: [CBCharacteristic], discoverAllSupportedService: Bool) {
        let uuids = charList.map{$0.uuid.uuidString}
        let uuid = SupportedService.sharedInstance.writeCharacteristicUUID
        if uuids.contains(uuid) {
            ScaleModel.sharedInstance.readySetCommand = true
        }
    }
    
    func didReadRSSI(rssi: NSNumber, error: Error?) {
        if let err = error{
            log.info("[didReadRSSI] Error: \(err.localizedDescription)")
        }
    }
}


