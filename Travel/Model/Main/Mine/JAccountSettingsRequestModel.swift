//
//  JAccountSettingsRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JAccountSettingsRequestModel: JBaseRequestModel {
    
    private var introduce = ""
    private var mobilePhone = ""
    private var userName = ""
    private var imageUrl = ""
    
    init(introduce: String,
         mobilePhone: String,
         userName: String,
         imageUrl: String) {
        super.init()
        self.introduce = introduce
        self.mobilePhone = mobilePhone
        self.userName = userName
        self.imageUrl = imageUrl
    }
    
    override func url() -> String {
        return super.url() + "api/user/\(JUserManager.sharedInstance.user?.userId ?? "")"
    }
    
    override func toBody() -> [String : Any] {
        var body : [String : Any] = [:]
        if imageUrl.count > 0 {
            body["icon"] = imageUrl
        }
        if mobilePhone.count > 0 {
            body["criteria"] = mobilePhone
        }
        if userName.count > 0 {
            body["userName"] = userName
        }
        if introduce.count > 0 {
            body["introduce"] = introduce
        }
        return body
    }
}
