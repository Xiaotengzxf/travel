//
//  cmdProxy.swift
//  Headset
//
//  Created by 方仁佑 on 2016/5/11.
//  Copyright © 2016年 jayfang. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class CMDProxy :  NSObject, characteristicChangeDelegate {
    
    let config = CMDConfig()
    
    func initCmdPorxy() {
        BLEPeripheral.sharedInstance.regCharacteristicChangeDelegate("proxy", delegate: self)
    }

    //
    // peripherial delegate
    //
    func characteristicChange(char:CBCharacteristic) -> Bool {
        guard let data = char.value else {
            return false
        }
        if let cmds = config.parseCmds(data: data) {
            var res = true
            for (key, value) in cmds {
                let result = JCMDManager.sharedInstance.getCMDBase(cmd: key)?.notifyData(data: value) ?? false
                print("key: \(key) value: \(value.hexEncodedStringNoBlank()) result: \(result)")
                if !result {
                    res = false
                }
            }
            return res
        }
        return false
    }

    func peripheralActivityChange(activePeripheral: CBPeripheral?) {
        
    }

}
