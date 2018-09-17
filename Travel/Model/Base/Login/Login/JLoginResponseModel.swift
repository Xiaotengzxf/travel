//
//  JLoginResponseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/1.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginResponseModel: Codable {
    
    var errCode : Int?
    var errMsg : String?
    var data: UserInfo?
}

class UserInfo: NSObject, Codable, NSCoding {
    var userId: String?
    var userIcon: String?
    var type: String?
    var token: String?
    var roleId: String?
    var roleResourceStr: String?
    var userName: String?
    var authRefresh: String?
    var organizationId: String?
    var organizationName: String?
    var wxAccessToken: String?
    var openId: String?
    var mobilePhone: String?
    var introduce: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        userIcon = aDecoder.decodeObject(forKey: "userIcon") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        roleId = aDecoder.decodeObject(forKey: "roleId") as? String
        roleResourceStr = aDecoder.decodeObject(forKey: "roleResourceStr") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        authRefresh = aDecoder.decodeObject(forKey: "authRefresh") as? String
        organizationId = aDecoder.decodeObject(forKey: "organizationId") as? String
        organizationName = aDecoder.decodeObject(forKey: "organizationName") as? String
        wxAccessToken = aDecoder.decodeObject(forKey: "wxAccessToken") as? String
        openId = aDecoder.decodeObject(forKey: "openId") as? String
        mobilePhone = aDecoder.decodeObject(forKey: "mobilePhone") as? String
        introduce = aDecoder.decodeObject(forKey: "introduce") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(userIcon, forKey: "userIcon")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(roleId, forKey: "roleId")
        aCoder.encode(roleResourceStr, forKey: "roleResourceStr")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(authRefresh, forKey: "authRefresh")
        aCoder.encode(organizationId, forKey: "organizationId")
        aCoder.encode(organizationName, forKey: "organizationName")
        aCoder.encode(organizationName, forKey: "wxAccessToken")
        aCoder.encode(organizationName, forKey: "openId")
        aCoder.encode(organizationName, forKey: "mobilePhone")
        aCoder.encode(introduce, forKey: "introduce")
    }
}


