//
//  JMenuPresenterDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/4/24.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JMenuPresenterDelegate: NSObjectProtocol {
    func didSelect(_ option: String, _ at: Int)
    func login()
    func getLoginStatus() -> Bool
    func editProfile()
    func currentUserName() -> String?
    func viewPolicy(idx: Int)


    func callbackDidLogout()
    func callbackDidSelect(_ option: String, _ idx: Int)
    
    func requestForShoppingActivity(callback: @escaping (String?, String?) -> ())
}

