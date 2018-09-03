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
            return "http://120.79.28.173:8080/travel/"
        #else
            return "http://120.79.28.173:8080/travel/"
        #endif
    }
    
    internal func toHeader() -> [String : String] {
        return ["AppId" : AppId]
    }
    
    internal func toBody() -> [String : Any] {
        return [:]
    }
    
}


