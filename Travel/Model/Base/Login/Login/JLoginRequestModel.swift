//
//  JLoginRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/4/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginRequestModel: JBaseRequestModel {
    
    private var mobilePhone = ""
    private var password = ""
    
    init(mobilePhone: String, password: String) {
        super.init()
        self.mobilePhone = mobilePhone
        self.password = password
    }
    
    override func url() -> String {
        return super.url() + "api/user-token"
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["mobilePhone"] = mobilePhone
        dic["password"] = password
        return dic
    }
}
