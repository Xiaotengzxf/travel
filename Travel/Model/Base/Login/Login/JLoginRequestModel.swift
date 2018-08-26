//
//  JLoginRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginRequestModel: JBaseRequestModel {
    
    private var email = ""
    private var password = ""
    
    init(email: String, password: String) {
        super.init()
        self.email = email
        self.password = password
    }
    
    override func url() -> String {
        return super.url() + "user/v2/email/login"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["email"] = email
        dic["password"] = password
        return dic
    }
}
