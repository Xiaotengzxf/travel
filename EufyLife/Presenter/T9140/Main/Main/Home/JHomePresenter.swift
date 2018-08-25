//
//  JHomePresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHomePresenter: NSObject {
    
    private var modelService: JHomeDelegate!
    
    override init() {
        super.init()
        modelService = JHomeModelService(presenter: self)
    }
}

extension JHomePresenter: JHomeDelegate {
    
    func getMemberCount() -> Int {
        return modelService.getMemberCount()
    }
}
