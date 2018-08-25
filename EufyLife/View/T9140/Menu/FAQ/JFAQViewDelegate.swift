//
//  JFAQViewDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JFAQViewDelegate: NSObjectProtocol{
    func callbackFAQ(objs: [FAQObj]?)
}
