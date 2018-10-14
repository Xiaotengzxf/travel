//
//  JLoginUserInfoRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/12.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JLoginUserInfoRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/user/\(JUserManager.sharedInstance.user?.userId ?? "")"
    }

}

class Resource: Codable {
    var accessUrl: String?
    var deleted: Bool?
    var id: String?
    var name: String?
    var operation: String?
    var operationName: String?
    var parentId: String?
    var sortIndex: Int?
    var status: String?
    var treePath: String?
}

class Role: Codable {
    var createTime: String?
    var createUserId: String?
    var deleted: Bool?
    var description: String?
    var id: String?
    var name: String?
    var organizationId: String?
    var organizationName: String?
    var resourceIdList: [String]?
    var resourceList: [Resource]?
    var status: String?
}

class User: Codable {
    var age: Int?
    var birthday: String?
    var chatId: String?
    var createTime: Int?
    var createUserId: String?
    var deleted: Bool?
    var email: String?
    var fansNumber: Int?
    var focusNumber: Int?
    var gender: String?
    var icon: String?
    var id: String?
    var introduce: String?
    var mobilePhone: String?
    var nickName: String?
    var organizationId: String?
    var organizationName: String?
    var password: String?
    var realName: String?
    var roleIdList: [String]?
    var roleList: [Role]?
    var status: String?
    var type: String?
    var userName: String?
    var verifyCode: String?
}

class LoginUserInfoModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: User?
    
}
