//
//  JRegisterRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRegisterRequestModel: JBaseRequestModel {
    private var mobilePhone = ""
    private var password = ""
    private var code = ""
    
    init(mobilePhone: String, password: String, code: String) {
        super.init()
        self.mobilePhone = mobilePhone
        self.password = password
        self.code = code
    }
    
    override func url() -> String {
        return super.url() + "api/user-register"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["mobilePhone"] = mobilePhone
        dic["password"] = password
        dic["verifyCode"] = code
        return dic
    }
}
