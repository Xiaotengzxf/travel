//
//  JForgetPWDPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDPresenter: NSObject {
    
    var viewDelegate: JForgetPWDViewDelegate?
    var modelService: JForgetPWDModelServiceDelegate?
    
    init(viewDelegate: JForgetPWDViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JForgetPWDModelService(presenter: self)
    }
}

extension JForgetPWDPresenter: JForgetPWDPresenterDelegate {
    
    func forgetPWD(email: String, callback: @escaping (Bool, String?) -> ()) {
        modelService?.forgetPWD(email: email, callback: callback)
    }

}
