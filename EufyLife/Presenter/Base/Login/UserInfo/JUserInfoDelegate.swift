//
//  JUserInfoDelegate.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

protocol JUserInfoDelegate: NSObjectProtocol {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?)->())
}

protocol JUserInfoCallbackDelegate: NSObjectProtocol {
    
}
