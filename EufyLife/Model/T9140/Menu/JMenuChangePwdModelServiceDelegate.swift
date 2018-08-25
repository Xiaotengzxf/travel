//
//  JMenuChangePwdModelServiceDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/6/1.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation


protocol JMenuChangePwdModelServiceDelegate: NSObjectProtocol {
    func changePassword(oldPassword: String, newPassword: String)
}
