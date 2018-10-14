//
//  JForgetPWDRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/7.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDRequestModel: JBaseRequestModel {
    
    private var password = ""
    private var phone = ""
    private var code = ""
    
    init(phone: String, password: String, code: String) {
        super.init()
        self.phone = phone
        self.password = password
        self.code = code
    }
    
    override func url() -> String {
        return super.url() + "api/user-password"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["mobilePhone"] = phone
        dic["password"] = password
        dic["verifyCode"] = code
        return dic
    }
}
