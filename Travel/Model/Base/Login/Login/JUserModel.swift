//
//  JUserModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUserModel: NSObject, NSCoding, Codable {
    
    var access_token : String?
    var email : String?
    var avatar: String?
    var gender: String?
    var expires_in : Int?
    var nick_name : String?
    var refresh_token : String?
    var token_type : String?
    var user_id : String?
    var customer_count : Int?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? Int
        nick_name = aDecoder.decodeObject(forKey: "nick_name") as? String
        refresh_token = aDecoder.decodeObject(forKey: "refresh_token") as? String
        token_type = aDecoder.decodeObject(forKey: "token_type") as? String
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        customer_count = aDecoder.decodeObject(forKey: "customer_count") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(nick_name, forKey: "nick_name")
        aCoder.encode(refresh_token, forKey: "refresh_token")
        aCoder.encode(token_type, forKey: "token_type")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(customer_count, forKey: "customer_count")
    }
    
}

