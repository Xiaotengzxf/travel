//
//  JForgetPWDPresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JForgetPWDPresenterDelegate: NSObjectProtocol {
    
    /// 忘记密码
    ///
    /// - Parameters:
    ///   - email: 邮箱
    func forgetPWD(email: String, callback: @escaping (Bool, String?) -> ())
    
}
