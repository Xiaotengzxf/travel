//
//  JRootPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/6/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRootPresenter: NSObject {
    
    var modelService: JRootModelServiceDelegate?
    
    override init() {
        super.init()
        modelService = JRootModelService()
    }
}

extension JRootPresenter: JRootPresenterDelegate {
    
}
