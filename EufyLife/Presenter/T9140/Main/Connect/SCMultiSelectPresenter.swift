//
//  SCMultiSelectPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/1/10.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCMultiSelectPresenter: NSObject {
    var modelService: JMultiSelectDelegate?
    
    override init() {
        super.init()
        modelService = SCMultiSelectModelService(presenter: self)
    }
}

extension SCMultiSelectPresenter: JMultiSelectDelegate {
    func getDeviceListCount() -> Int {
        return modelService?.getDeviceListCount() ?? 0
    }
    
    func getDeviceName() -> [String] {
        return modelService?.getDeviceName() ?? []
    }
    
}
