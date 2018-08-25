//
//  AirohaDefs.swift
//  CMD
//
//  Created by AirohaTool on 2016/10/10.
//  Copyright © 2016年 AirohaTool. All rights reserved.
//

import Foundation

/**
 AirohaErrorCode: Int type, 1-255 return from command response
 
 -1 : command timeout
 
 -2 : can not find the write characteristic of airoha command
 
 -3 : peripheral not found, make sure setPeripheral() have been invoked and still connected
 
 -4 : parameter taken error
 
 */
@objc open class ErrorCode: NSObject {
    fileprivate override init() {}
    @objc open class func timeout() -> Int {return -1}
    @objc open class func writeCharacteristicNotFound() -> Int {return -2}
    @objc open class func peripheralNotFound() -> Int {return -3}
    @objc open class func parameterError() -> Int {return -4}
}


