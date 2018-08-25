//
//  JUserInfoPresenter.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUserInfoPresenter: NSObject {
    private var modelService: JUserInfoDelegate!
    
    override init() {
        super.init()
        modelService = JUserInfoModelService()
    }
}

extension JUserInfoPresenter: JUserInfoDelegate {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?)->()) {
        modelService.addCustomer(name: name, sex: sex, age: age, height: height, callback: callback)
    }
}
