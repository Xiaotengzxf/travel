//
//  JScaleSettingModelService.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JScaleSettingModelService: NSObject {
    
}

extension JScaleSettingModelService: JScaleSettingDelegate {
    func getDevice(index: Int) -> Device {
        return JUserManager.sharedInstance.deivces[index]
    }
}
