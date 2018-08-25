//
//  JSideMenuDelegate.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

protocol JSideMenuDelegate: NSObjectProtocol {
    func getTableViewCellNum() -> Int
    func getTableViewCellData(row: Int) -> (String, String)
    func getEmail() -> String
    func getMemberCount() -> Int
    func getMemberInfo(row: Int) -> Customer
    func getUserInfo() -> String
}

protocol JSideMenuCallbackDelegate: NSObjectProtocol {
    func callbackForRefreshMember()
    func callbackForRefreshUserInfo()
}
