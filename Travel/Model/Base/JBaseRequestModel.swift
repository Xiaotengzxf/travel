//
//  JBaseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JBaseRequestModel: NSObject {
    
    private let AppId = "travel"
    
    internal func url() -> String {
        #if DEBUG
            return kDEBUGUrl
        #else
            return kDEBUGUrl
        #endif
    }
    
    internal func toHeader() -> [String : String] {
        if let token = JUserManager.sharedInstance.user?.token {
            return ["Authorization": token, "AppId" : AppId]
        }
        return ["AppId" : AppId]
    }
    
    internal func toBody() -> [String : Any] {
        return [:]
    }
    
}


