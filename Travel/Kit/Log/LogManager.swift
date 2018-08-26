//
//  LogManager.swift
//  Jouz
//
//  Created by ANKER on 2017/12/14.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class LogManager: NSObject {
    
    static let sharedInstance = LogManager()
    let log = Log.default
    
    override init() {
        super.init()
        
    }
    
    func setupLog() {
        #if DEBUG
        if let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "\(filePath)/Jouz.log" as AnyObject)
        }
        #else
            if let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                log.setup(level: .info, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "\(filePath)/Jouz.log" as AnyObject)
            }
        #endif
    }
}
