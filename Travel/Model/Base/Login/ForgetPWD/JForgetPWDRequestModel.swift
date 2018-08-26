//
//  JForgetPWDRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/7.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDRequestModel: JBaseRequestModel {
    
    private var email = ""
    
    init(email: String) {
        super.init()
        self.email = email
    }
    
    override func url() -> String {
        return super.url() + "user/password/forget?email=\(email)"
    }
}
