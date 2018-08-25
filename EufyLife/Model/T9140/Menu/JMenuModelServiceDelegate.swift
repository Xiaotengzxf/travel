//
//  JMenuModelServiceDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/4/24.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JMenuModelServiceDelegate {
    func getLoginStatus() -> Bool
    func currentUserName() -> String?
    func didSelect(_ option: String, _ idx: Int)
    func requestPolicyInfo(completion: ((String?, String?, String?) -> Void)?)
    func requestForShoppingActivity(callback: @escaping (String?, String?) -> ())
}
