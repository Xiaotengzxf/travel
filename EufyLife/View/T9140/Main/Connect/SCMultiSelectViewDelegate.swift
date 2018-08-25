//
//  SCMultiSelectViewDelegate.swift
//  Jouz
//
//  Created by ANKER on 2017/12/26.
//  Copyright © 2017年 team. All rights reserved.
//

import Foundation

protocol SCMultiSelectViewDelegate: NSObjectProtocol {
    func callbackForRefreshTableView()
    func callbackForRefreshTableData(needBack: Bool)
    func callbackForRefreshButton(result: Bool?)
    func callbackForConnected()
}
