//
//  JHeatStickModelServiceDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/4/20.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JHeatStickModelServiceDelegate: NSObjectProtocol {
    
    /// 获取所有烟草列表
    func getHeatSticks() -> [String]
    
    /// 获取当前的烟草
    ///
    /// - Returns: 序号
    func getHeatStick() -> (Int, Int)
    
    /// 设置烟草口味
    ///
    /// - Parameter index: 序号
    func setHeatStick(index: Int)
    
    func getBrands() -> [String]
    
    func getBrand() -> Int
    
    func setBrand(index: Int)
    
}
