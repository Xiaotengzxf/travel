//
//  JFeedbackPresenterDelegate.swift
//  Jouz
//
//  Created by doubll on 2018/6/6.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JFeedbackPresenterDelegate: NSObjectProtocol {
    func submitFeedback(content: String, completion: ((Bool, String?) -> Void)?)
}
