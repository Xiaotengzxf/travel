//
//  JRegisterRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRegisterRequestModel: JBaseRequestModel {
    private var email = ""
    private var password = ""
    private var nickName = ""
    private var isSubscribe = false
    
    init(email: String, password: String, nickName: String, isSubscribe: Bool) {
        super.init()
        self.email = email
        self.password = password
        self.nickName = nickName
        self.isSubscribe = isSubscribe
    }
    
    override func url() -> String {
        return super.url() + "user/email/register"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["email"] = email
        dic["password"] = password
        dic["name"] = nickName
        dic["un_subscribe_flag"] = isSubscribe
        return dic
    }
}
