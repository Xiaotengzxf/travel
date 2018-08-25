//
//  JLoginPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginPresenter: NSObject {
    
    weak var viewDelegate: JLoginViewDelegate?
    var modelService: JLoginModelServiceDelegate?
    
    init(viewDelegate: JLoginViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JLoginModelService(presenter: self)
    }
}

extension JLoginPresenter: JLoginPresenterDelegate {
    
    func login(email: String, password: String, callback: @escaping (Bool, String?, Bool) -> ()) {
        modelService?.login(email: email, password: password, callback: callback)
    }

}
