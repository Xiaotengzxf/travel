//
//  CMDBase.swift
//  Jouz
//
//  Created by ANKER on 2018/1/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class CMDBase: NSObject {
    
    var _cmdCompleteFlag = false
    var timeoutTimer: Timer?
    private var cmd: Int!
    private var addCmdToQueue = false
    private let config = CMDConfig()
    
    init(cmd: Int) {
        super.init()
        self.cmd = cmd
    }
    
    func sendCmd(parameter: Data?, toQueue: Bool, needTimeOut: Bool = true) {
        addCmdToQueue = toQueue
        if addCmdToQueue {
            if (lockCenter.sharedInstance.isLocked() ){
                return
            }
            let _ = lockCenter.sharedInstance.lock(name: cmd)
        }
        let uuid = SupportedService.sharedInstance.writeCharacteristicUUID
        let data = joinCmd(parameter: parameter)
        BLEPeripheral.sharedInstance.writeCharacteristics(uuid, data: data)
        _cmdCompleteFlag = false
        
        if needTimeOut {
            if timeoutTimer != nil {
                timeoutTimer?.invalidate()
                timeoutTimer = nil
            }
            DispatchQueue.main.async {
                self.timeoutTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.cmdTimeout), userInfo: nil, repeats: false)
            }
        }
    }
    
    // TODO: - 拼接指令，需要优化
    private func joinCmd(parameter: Data?) -> Data {
        let mData = NSMutableData()
        mData.append(config.cmdHead())
        let prefix = config.addPrefix(cmd: cmd)
        if prefix > 0x00 {
            mData.appendUInt8(prefix)
        }
        mData.appendUInt8(UInt8(cmd))
        if parameter != nil {
            mData.append(parameter!)
        }
        mData.appendUInt8(config.addSupfix(cmd: cmd))
        let sData = mData.subdata(with: NSMakeRange(2, mData.length - 2))
        mData.appendUInt8(config.checkSum(data: sData))
        return mData as Data
    }
    
    func notifyData(data : Data) -> Bool {
        if !config.validateCmdHead(data: data) {
            return false
        }
        if data.count < 10 && !config.validateCheckSum(data: data) {
            print("Check Sum fail")
            return false
        }
        let value = config.parseCmd(data: data)
        actionWithData(value)
        return true
    }
    
    func actionWithData(_ data: Data?) {
        //if ind , unlock
        cmdFlowCompleteAndUnlock()
        ZFramework.sharedInstance._controlModule.AirohaSingleCmd(cmdType: cmd, didReturnValue: data, error: nil)
    }
    
    @objc func cmdTimeout(){
        if ( _cmdCompleteFlag == true) {
            return
        }
        cmdFlowCompleteAndUnlock()
       ZFramework.sharedInstance._controlModule.AirohaSingleCmd(cmdType: cmd, didReturnValue: nil, error: ErrorCode.timeout() as NSNumber?)
    }
    
    func cmdFlowCompleteAndUnlock() {
        if timeoutTimer != nil {
            timeoutTimer?.invalidate()
            timeoutTimer = nil
        }
        _cmdCompleteFlag = true
        if addCmdToQueue {
            let _ = lockCenter.sharedInstance.unlock(name: cmd)
        }
    }
}
