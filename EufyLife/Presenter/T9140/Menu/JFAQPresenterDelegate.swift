//
//  JFAQPresenterDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JFAQPresenterDelegate: NSObjectProtocol {
    func requestFAQInfo() -> [FAQObj]?
    func contactEvent()
}
