//
//  JRenameModelServiceDelegate.swift
//  Jouz
//
//  Created by ANKER on 2018/1/2.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

protocol JRenameModelServiceDelegate: NSObjectProtocol {
    func getDeviceName() -> String
    func setDeviceName(text: String)
    func getSuggestionName() -> String
}
