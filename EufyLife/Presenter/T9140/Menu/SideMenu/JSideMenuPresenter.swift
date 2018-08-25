//
//  JSideMenuPresenter.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSideMenuPresenter: NSObject {
    
    private var modelService: JSideMenuDelegate!
    private weak var viewDelegate: JSideMenuCallbackDelegate?
    
    init(viewDelegate: JSideMenuCallbackDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JSideMenuModelService(presenter: self)
    }
}

extension JSideMenuPresenter: JSideMenuDelegate {
    func getTableViewCellData(row: Int) -> (String, String) {
        return modelService.getTableViewCellData(row: row)
    }
    
    func getTableViewCellNum() -> Int {
        return modelService.getTableViewCellNum()
    }
    
    func getEmail() -> String {
        return modelService.getEmail()
    }
    
    func getMemberCount() -> Int {
        return modelService.getMemberCount()
    }
    
    func getMemberInfo(row: Int) -> Customer {
        return modelService.getMemberInfo(row: row)
    }
    
    func getUserInfo() -> String {
        return modelService.getUserInfo()
    }
    
}

extension JSideMenuPresenter: JSideMenuCallbackDelegate {
    func callbackForRefreshMember() {
        viewDelegate?.callbackForRefreshMember()
    }
    
    func callbackForRefreshUserInfo() {
        viewDelegate?.callbackForRefreshUserInfo()
    }
}
