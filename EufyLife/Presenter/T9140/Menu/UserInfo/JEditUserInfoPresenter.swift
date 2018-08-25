//
//  JEditUserInfoPresenter.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JEditUserInfoPresenter: NSObject {
    private var modelService: JEditUserInfoDelegate!
    
    override init() {
        super.init()
        modelService = JEditUserInfoModelService()
    }
}

extension JEditUserInfoPresenter: JEditUserInfoDelegate {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?) -> ()) {
        modelService.addCustomer(name: name, sex: sex, age: age, height: height, callback: callback)
    }
    
    func deleteCustomer(customerId: String, callback: @escaping (Bool, String?) -> ()) {
        modelService.deleteCustomer(customerId: customerId, callback: callback)
    }
    
    func editCustomer(customer: Customer, callback: @escaping (Bool, String?) -> ()) {
        modelService.editCustomer(customer: customer, callback: callback)
    }
}
