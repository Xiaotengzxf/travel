//
//  JLoginModelServiceDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

protocol JLoginModelServiceDelegate: NSObjectProtocol {
    
    /// 登录
    /// view -> presenter
    /// - Parameters:
    ///   - email: 邮箱
    ///   - password: 密码
    func login(email: String, password: String, callback: @escaping (Bool, String?, Bool) -> ())
    
}
