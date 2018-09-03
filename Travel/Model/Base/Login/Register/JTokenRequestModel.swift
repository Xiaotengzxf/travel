//
//  JTokenRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/1.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JTokenRequestModel: JBaseRequestModel {
    private var mobilePhone = ""
    
    init(mobilePhone: String) {
        super.init()
        self.mobilePhone = mobilePhone
    }
    
    override func url() -> String {
        return super.url() + "api/user-verify-code"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["mobilePhone"] = mobilePhone
        return dic
    }
}
