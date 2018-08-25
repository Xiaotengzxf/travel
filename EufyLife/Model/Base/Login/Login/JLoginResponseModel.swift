//
//  JLoginResponseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/1.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginResponseModel: Codable {
    
    var res_code : Int?
    var message : String?
    var access_token : String?
    var email : String?
    var expires_in : Int?
    var refresh_token : String?
    var token_type : String?
    var user_id : String?
    var avatar: String?
    var user_info: UserInfo?
    var customers: [Customer]?
    var devices: [Device]?
}

class UserInfo: Codable {
    var id: String?
    var nick_name: String?
    var email: String?
    var timezone: String?
    var avatar: String?
}

class Customer: Codable {
    var avatar : String?
    var birthday = 0
    var customer_no = 0
    var defaultValue = true
    var height = 0
    var id : String?
    var index = 0
    var name : String?
    var sex: String?
    var target_weight = 0
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case birthday
        case customer_no
        case defaultValue = "default"
        case height
        case id
        case index
        case name
        case sex
        case target_weight
    }
}

class Device: Codable {
    var alias_name: String?
    var connect_type = 0
    var create_time = 0
    var device_key: String?
    var id: String?
    var index = 0
    var name: String?
    var user_id: String?
    var sn: String?
    var bluetooth: BlueTooth?
    var software_version: String?
}

class BlueTooth: Codable {
    var ble_mac: String?
    var name: String?
    var std_mac: String?
}


extension JLoginResponseModel {
    func responseToUser() -> JUserModel? {
        let user = JUserModel()
        user.access_token = access_token ?? ""
        user.email = email ?? ""
        user.expires_in = expires_in ?? 0
        user.refresh_token = refresh_token ?? ""
        user.token_type = token_type ?? ""
        user.user_id = user_id ?? ""
        user.avatar = avatar ?? ""
        user.nick_name = user_info?.nick_name ?? ""
        user.customer_count = customers?.count ?? 0
        return user
    }
}
