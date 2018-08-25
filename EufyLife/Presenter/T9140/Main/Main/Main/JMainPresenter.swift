//
//  SCMainPresenter.swift
//  Jouz
//
//  Created by ANKER on 2017/12/26.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class JMainPresenter: NSObject {
    
    var modelService: JMainDelegate!
    weak var viewDelegate: JMainCallbackDelegate?
    
    init(viewDelegate: JMainCallbackDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JMainModelService(presenter: self)
    }
    
}

// MARK: - SCMainPresenterDelegate

extension JMainPresenter: JMainDelegate {
    
    func getBackgroundImages() -> [UIImage] {
        return modelService.getBackgroundImages()
    }
    
    func getDeviceCount() -> Int {
        return modelService.getDeviceCount()
    }
    
    func getCurrentMemberName() -> String {
        return modelService.getCurrentMemberName()
    }
    
    func getDeviceInfoes() -> [Device] {
        return modelService.getDeviceInfoes()
    }
    
    func getMemberCount() -> Int {
        return modelService.getMemberCount()
    }
    
    func getMemberInfo(row: Int) -> Customer {
        return modelService.getMemberInfo(row: row)
    }
    
}

extension JMainPresenter: JMainCallbackDelegate {
    func callbackScaleData(weight: String) {
        viewDelegate?.callbackScaleData(weight: weight)
    }
    
    func callbackConnectState(state: String) {
        viewDelegate?.callbackConnectState(state: state)
    }
}
