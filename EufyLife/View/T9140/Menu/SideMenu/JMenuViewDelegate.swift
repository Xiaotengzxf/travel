//
//  JMenuViewDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/4/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

protocol JMenuViewDelegate: NSObjectProtocol {
    func callbackDidSelect(_ option: String, _ idx: Int)
    func callbackDidLogin(userName: String)
    func callbackDidLogout()
}
