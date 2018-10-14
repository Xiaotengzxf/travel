//
//  JCircleListResponseModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCircleListResponseModel: Codable {
    var errCode = 0
    var errMsg: String?
    var data: [Circle]?
}

class Circle: Codable {
    var id : String?
    var name : String?
    var description : String?
    var number : String?
    var imageUrl : String?
    var type : String?
    var status : String?
    var tags : String?
    var sortIndex : String?
    var createUserId : String?
    var ownerUserId : String?
    var createTime : TimeInterval?
    var activityId : String?
    var chatGroupId : String?
    var activityName : String?
    var ownerUserName : String?
    var createUserName : String?
    var circleUserList : [CircleUser]?
}

class CircleUser: Codable {
    var circleId : String?
    var circleName : String?
    var createTime : TimeInterval?
    var id : String?
    var isManager : Bool?
    var nickName : String?
    var status : String?
    var type : String?
    var user: User?
    var userId : String?
    var userName : String?
}
