//
//  cmdLock.swift
//  CMD
//
//  Created by AirohaTool on 2016/10/14.
//  Copyright © 2016年 AirohaTool. All rights reserved.
//

import Foundation

class lockCenter :  NSObject {
    static let sharedInstance = lockCenter()
    fileprivate override init(){}
    
    var _locked = false
    var _lockname : Int?
    
    //
    //  Lock / Unlock
    //
    func lock(name: Int) -> Bool{
        if (lockCenter.sharedInstance._locked == true) {
            log.info("[CMD][Lock] already locked , can't lock again")
            return false
        } else {
            lockCenter.sharedInstance._locked = true
            lockCenter.sharedInstance._lockname = name
            return true
        }
    }
    
    func unlock( name: Int) -> Bool {
        if ( lockCenter.sharedInstance._lockname != name && lockCenter.sharedInstance._lockname != nil){
            log.info("[CMD][Lock] unlock name not match \(lockCenter.sharedInstance._lockname!) : \(name)")
            return false
        }
        lockCenter.sharedInstance._locked = false
        lockCenter.sharedInstance._lockname = nil
        return true
    }
    
    func isLocked() -> Bool {
        return lockCenter.sharedInstance._locked
    }
    
    func getLockedName() -> Int? {
        return lockCenter.sharedInstance._lockname
    }
    
    func resetLocker() {
        lockCenter.sharedInstance._locked = false
        lockCenter.sharedInstance._lockname = nil
    }
    
    func preRunCheck(cmdItem: Int, funcName: String, writeUUID: String) -> Int {
        if !BLEPeripheral.sharedInstance.isPeripheralValid() {
            ZFramework.sharedInstance._controlModule.AirohaSingleCmd(cmdType: cmdItem, didReturnValue: nil, error: ErrorCode.peripheralNotFound() as NSNumber?)
            return -2
        }
        if BLEPeripheral.sharedInstance.getCharByUUID(writeUUID) == nil {
            ZFramework.sharedInstance._controlModule.AirohaSingleCmd(cmdType: cmdItem, didReturnValue: nil, error: ErrorCode.writeCharacteristicNotFound() as NSNumber?)
            return -3
        }
        return 0
    }

    
}
