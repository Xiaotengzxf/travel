//
//  JScaleSettingDelegate.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JScaleSettingDelegate: NSObjectProtocol {
    func getDevice(index: Int) -> Device
}
