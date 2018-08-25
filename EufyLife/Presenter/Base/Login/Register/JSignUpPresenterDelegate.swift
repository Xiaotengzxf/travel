//
//  JSignUpPresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JSignUpPresenterDelegate: NSObjectProtocol {
    
    /// 注册
    ///
    /// - Parameters:
    ///   - email: 邮箱
    ///   - password: 密码
    ///   - name: 名称
    func signUp(email: String, password: String, name: String, isSubscribe: Bool, callback: @escaping (Bool, String?) -> ())
    
}
