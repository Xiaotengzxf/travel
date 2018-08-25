//
//  JMoreModelServiceDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/4/23.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JMoreModelServiceDelegate: NSObjectProtocol {
    
    /// 获取名称
    ///
    /// - Returns: 名称
    func getLocalName() -> String
    
    /// 获取童锁状态
    ///
    /// - Returns: 是否开启
    func getChildLockStatus() -> Bool
    
    /// 设置童锁
    ///
    /// - Parameter value: 是否开启
    func setChildLockStatus(value: Bool)
    
    /// 断开连接
    func disconnect()
    
    func getNeedUpdate() -> Bool
}
