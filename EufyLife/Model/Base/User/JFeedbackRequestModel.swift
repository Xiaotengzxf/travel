//
//  JFeedbackRequestModel.swift
//  Jouz
//
//  Created by doubll on 2018/6/7.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JFeedbackRequestModel: JBaseRequestModel {
    private var token: String? = JUserManager.sharedInstance.user?.access_token
    private var uid: String? = JUserManager.sharedInstance.user?.user_id
    var device_sn: String?
    var message: String?
    var user_phone_model: String? = UIDevice.current.model
    var user_phone_os: String? = "iOS"
    var user_phone_type: String? = "Apple"

    override func url() -> String {
       return super.url() + "help/feedback/S6020"
    }

    override func toHeader() -> [String : String] {
        var dic = super.toHeader()
        dic["token"] = token
        dic["uid"] = uid
        return dic
    }

    override func toBody() -> [String : Any] {
        var body = [String : Any]()
        body["device_sn"] = device_sn
        body["message"] = message
        body["user_phone_model"] = user_phone_model
        body["user_phone_os"] = user_phone_os
        body["user_phone_type"] = user_phone_type
        return body
    }
}


struct JFeedbackResponseModel: Decodable {
    var res_code: Int
    var message: String?
}
