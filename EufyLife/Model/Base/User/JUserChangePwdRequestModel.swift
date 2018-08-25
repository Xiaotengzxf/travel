//
//  JUserChangePwdRequestModel.swift
//  Jouz
//
//  Created by doubll on 2018/6/1.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JUserChangePwdRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    override func url() -> String {
        return super.url() + "user/password/change"
    }
    var newPassword: String?
    var oldPassword: String?


    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }

    override func toBody() -> [String : Any] {
        var body: [String: String] = [:]
        body["old_password"] = oldPassword
        body["new_password"] = newPassword
        return body
    }
}
