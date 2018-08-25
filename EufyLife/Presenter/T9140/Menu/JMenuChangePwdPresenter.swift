//
//  JMenuChangePwdPresenter.swift
//  Jouz
//
//  Created by doubll on 2018/6/1.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension JMenuChangePwdPresenter: JMenuChangePwdPresenterDelegate {
        func callback(passwordChanged success: Bool, msg: String?) {
        self.viewDelegate?.callback(passwordChanged: success, msg: msg)
    }

    func changePassword(oldPassword: String, newPassword: String) {
        self.modelService?.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
}

class JMenuChangePwdPresenter: NSObject {

    weak var viewDelegate: JMenuChangePwdViewDelegate?
    var modelService: JMenuChangePwdModelServiceDelegate?
    init(viewDelegate: JMenuChangePwdViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        self.modelService = JMenuChangePwdModelService(presenter: self)
    }
}
