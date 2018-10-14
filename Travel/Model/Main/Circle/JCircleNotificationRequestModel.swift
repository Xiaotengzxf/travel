//
//  JCircleNotificationRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCircleNotificationRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "/api/circle-join"
    }
    
}

class JCircleNotificationResponseModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: [CircleNotification]?
}

class CircleNotification: Codable {
    var id : String?
    var userId : String?
    var circleId : String?
    var toUserId : String?
    var type : String?
    var status : String?
    var remark : String?
    var source : String?
    var createTime : TimeInterval?
    var userIdList: String?
    var user: User?
}
