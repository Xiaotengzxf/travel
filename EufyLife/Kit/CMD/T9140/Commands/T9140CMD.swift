//
//  T9140CMD.swift
//  Jouz
//
//  Created by ANKER on 2018/5/9.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

@objc public enum T9140CMD: Int {
    case getHistoryData = 0x00 // App请求历史
    case syncLoalTime = 0xf2 // 同步当前时间
    case closeDevice = 0x1a // 关机
    case endDevice = 0x1c // 结束
    case getScaleUnit = 0x1b // 获取称单位
    case setScaleUint = 0x06 // 设置称单位
    case responseData = 0x1d // 应答
    case responseTimeData = 0xf1 // 返回测量时间
    case responseTimeFinished = 0x10 // 测量结束
    case impedanceData = 0xfd // 阻抗
    case currentData = 0xfe // 实际测试的数据
    case unknow = 0xff // 未知
}

extension T9140CMD: CMDProtocol {
    
    static func cmd() -> [Int] {
        return [0x00, 0xf2, 0x1a, 0x1b, 0x1c, 0x06, 0x1d, 0xf1, 0x10, 0xfd, 0xfe, 0x0ff]
    }
    
}
