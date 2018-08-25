//
//  JMorePresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/4/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMorePresenter: NSObject {
    
    weak var viewDelegate: JMoreViewDelegate?
    var modelService: JMoreModelServiceDelegate?
    
    init(viewDelegate: JMoreViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JMoreModelService(presenter: self)
    }
}

extension JMorePresenter: JMorePresenterDelegate {
    
    func getLocalName() -> String {
        return modelService?.getLocalName() ?? ""
    }
    
    func getChildLockStatus() -> Bool {
        return modelService?.getChildLockStatus() ?? false
    }
    
    func setChildLockStatus(value: Bool) {
        modelService?.setChildLockStatus(value: value)
    }
    
    func disconnect() {
        modelService?.disconnect()
    }
    
    func getNeedUpdate() -> Bool {
        return modelService?.getNeedUpdate() ?? false
    }
    
    func callback(childLock: Bool) {
        viewDelegate?.callback(childLock: childLock)
    }
    
    func callback(set: Bool) {
        
    }
    
    func callback(needUpdate: Bool) {
        viewDelegate?.callback(needUpdate: needUpdate)
    }
    
    func callbackForHideHUD() {
        viewDelegate?.callbackForHideHUD()
    }
    
    func callback(disconnectResult: Bool?) {
        viewDelegate?.callback(disconnectResult: disconnectResult)
    }
    
    func callback(setChildLockResult: Bool?) {
        viewDelegate?.callback(setChildLockResult: setChildLockResult)
    }
    
}
