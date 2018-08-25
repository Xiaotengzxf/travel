//
//  SCMultiSelectPresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/1/10.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JMultiSelectDelegate: NSObjectProtocol {
    func getDeviceListCount() -> Int
    func getDeviceName() -> [String]
    
}

protocol JMultiSelectCallbackDelegate: NSObjectProtocol {
    
}
