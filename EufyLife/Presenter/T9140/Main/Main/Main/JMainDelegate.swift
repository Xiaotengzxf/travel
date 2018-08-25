//
//  SCMainPresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/26.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

protocol JMainDelegate: NSObjectProtocol {
    
    func getBackgroundImages() -> [UIImage]
    func getMemberCount() -> Int
    func getMemberInfo(row: Int) -> Customer
    func getDeviceCount() -> Int
    func getDeviceInfoes() -> [Device]
    func getCurrentMemberName() -> String
}

protocol JMainCallbackDelegate: NSObjectProtocol {
    func callbackScaleData(weight: String)
    func callbackConnectState(state: String)
}
