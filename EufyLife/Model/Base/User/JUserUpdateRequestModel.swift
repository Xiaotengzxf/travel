//
//  JUserUpdateRequestModel.swift
//  Jouz
//
//  Created by doubll on 2018/5/18.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUserUpdateAvatarRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    var avatar: String = ""
    override func url() -> String {
        return super.url() + "user/avatar"
    }

    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }

    override func toBody() -> [String : Any] {
        var body: [String: String] = [:]
        body["avatar"] = avatar
        return body
    }
}

class JUserUpdateInfoRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    var user: JUserModel?
    override func url() -> String {
        return super.url() + "user/info"
    }

    init(user: JUserModel?) {
        super.init()
        self.user = user
    }

    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }

    override func toBody() -> [String : Any] {
        var body: [String: String] = [:]
        if let avatar = user?.avatar {
            body["avatar"] = avatar
        }
        if let id = user?.user_id {
            body["id"] = id
        }
        if let email = user?.email {
            body["email"] = email
        }
        if let gender = user?.gender {
            body["gender"] = gender
        }
        if let nick_name = user?.nick_name {
            body["nick_name"] = nick_name
        }
        return body
    }
}

class JUserDeleteAccountRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""

    override func url() -> String {
        return super.url() + "user/delete"
    }

    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        return header
    }
}

struct JUserDeleteAccountResponseModel: Codable {
    var res_code: Int
    var message: String?
}


class JUserPolicyRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""

    override func url() -> String {
        return super.url() + "help/privacy_and_terms"
    }
}

struct JUserPolicyResponseModel: Codable {
    var res_code: Int
    var message: String?
    var privacy_url: String?
    var terms_url: String?
}




