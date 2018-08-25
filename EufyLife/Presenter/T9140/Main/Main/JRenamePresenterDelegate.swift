//
//  JRenamePresenterDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/1/2.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JRenamePresenterDelegate: NSObjectProtocol {
    // View -> Presenter
    func getDeviceName() -> String?
    func setDeviceName(text: String)
    func getSuggestionName() -> String
    // Model -> Presenter
    func callback(isSuccess: Bool)
}
