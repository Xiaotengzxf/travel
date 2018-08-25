//
//  JEditUserInfoDelegate.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/23.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JEditUserInfoDelegate: NSObjectProtocol {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?)->())
    func deleteCustomer(customerId: String, callback: @escaping (Bool, String?) -> ())
    func editCustomer(customer: Customer, callback: @escaping (Bool, String?) -> ())
}
