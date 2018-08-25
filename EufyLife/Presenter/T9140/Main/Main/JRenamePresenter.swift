//
//  JRenamePresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/1/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRenamePresenter: NSObject {
    var modelService: JRenameModelServiceDelegate?
    weak var viewDelegate: JRenameViewDelegate?
    init(viewDelegate: JRenameViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JRenameModelService(presenter: self)
    }
}

extension JRenamePresenter: JRenamePresenterDelegate {
    
    func getDeviceName() -> String? {
        return modelService?.getDeviceName()
    }
    
    func setDeviceName(text: String) {
        modelService?.setDeviceName(text: text)
    }
    
    func getSuggestionName() -> String {
        return modelService?.getSuggestionName() ?? ""
    }
    
    func callback(isSuccess: Bool) {
        viewDelegate?.callback(isSuccess: isSuccess)
    }

}
