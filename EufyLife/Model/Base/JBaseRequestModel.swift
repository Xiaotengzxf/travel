//
//  JBaseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JBaseRequestModel: NSObject {
    
    private let timeZone = TimeZone.current.identifier
    private let country = Locale.current.regionCode ?? ""
    private let language = SCLanguageManager.sharedInstance.currentLanguage()
    private let category = "Health"
    private let clientId = "eufy-app"
    private let clientSecret = "8FHf22gaTKu7MZXqz5zytw"
    
    internal func url() -> String {
        #if DEBUG
            return "https://zhome-dev.eufylife.com/v1/"
        #else
            return "https://zhome-dev.eufylife.com/v1/"
        #endif
    }
    
    internal func toHeader() -> [String : String] {
        return ["timezone" : timeZone,
                 "country" : country,
                "language" : language,
                "category" : category,
                "openudid" : "1"]
    }
    
    internal func toBody() -> [String : Any] {
        return ["client_id" : clientId,
            "client_secret" : clientSecret]
    }
    
}


