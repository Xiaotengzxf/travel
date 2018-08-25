//
//  JUserUpdateResponseModel.swift
//  Jouz
//
//  Created by doubll on 2018/5/28.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JUserUpdateResponseModel: Codable {
    var res_code : Int?
    var message : String?
    var user_info: JUserInfoModel?
}

class JUserInfoModel: Codable {
    var user_id: String?
    var nick_name: String?
    var email: String?
    var avatar: String?
    var gender: String?

    enum CodingKeys: String, CodingKey {
        case user_id = "id"
        case nick_name
        case email
        case avatar
        case gender
    }
}

extension Dictionary {
    static func update(from a: Dictionary<String, Any>, to b: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var newDic = b
        for (key,value) in a {
            if newDic[key] != nil {
                newDic[key] = value
            }
        }
        return newDic
    }
}


