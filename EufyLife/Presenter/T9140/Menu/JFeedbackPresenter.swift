//
//  JFeedbackPresenter.swift
//  Jouz
//
//  Created by doubll on 2018/6/6.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension JFeedbackPresenter: JFeedbackPresenterDelegate {
    func submitFeedback(content: String, completion: ((Bool, String?) -> Void)?) {
        modelService.submitFeedback(content: content, completion: completion)
    }
}

extension JFeedbackPresenter: JFeedbackModelServiceDelegate {

}

class JFeedbackPresenter: NSObject {
    weak var viewDelegate: JFeedbackViewDelegate!
    var modelService: JFeedbackModelServiceDelegate!
    init(viewDelegate: JFeedbackViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        self.modelService = JFeedbackModelService(presenter: self)
    }
}
