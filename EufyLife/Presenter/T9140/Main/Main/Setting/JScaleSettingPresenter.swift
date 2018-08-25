//
//  JScaleSettingPresenter.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JScaleSettingPresenter: NSObject {
    private var modelService: JScaleSettingDelegate!
    
    override init() {
        super.init()
        modelService = JScaleSettingModelService()
    }
}

extension JScaleSettingPresenter: JScaleSettingDelegate {
    func getDevice(index: Int) -> Device {
        return modelService.getDevice(index: index)
    }
    
    
}
