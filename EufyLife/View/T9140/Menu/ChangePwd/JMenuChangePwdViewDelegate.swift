//
//  JMenuChangePwdViewDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/6/1.
//  Copyright © 2018年 team. All rights reserved.
//

protocol JMenuChangePwdViewDelegate: NSObjectProtocol {
    func callback(passwordChanged success: Bool, msg: String?)
}
