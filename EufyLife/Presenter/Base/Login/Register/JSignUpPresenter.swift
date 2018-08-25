//
//  JSignUpPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSignUpPresenter: NSObject {
    
    weak var viewDelegate: JSignUpViewDelegate?
    var modelService: JSignUpModelServiceDelegate?
    
    init(viewDelegate: JSignUpViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JSignUpModelService(presenter: self)
    }
}

extension JSignUpPresenter: JSignUpPresenterDelegate {
    
    func signUp(email: String, password: String, name: String, isSubscribe: Bool, callback: @escaping (Bool, String?) -> ()) {
        modelService?.signUp(email: email, password: password, name: name, isSubscribe: isSubscribe, callback: callback)
    }
    
}
