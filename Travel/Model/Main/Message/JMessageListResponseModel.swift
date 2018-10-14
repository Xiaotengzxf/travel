//
//  JMessageListResponseModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMessageListResponseModel: Codable {
    var errCode = 0
    var errMsg: String?
    var data: [Message]?
}

class Message: Codable {
    var id: String?
    var userId: String?
    var userIcon: String?
    var userName: String?
    var circleId: String?
    var circleName: String?
    var toUserId: String?
    var toUserName: String?
    var type: String?
    var status: String?
    var atUserIds: String?
    var atUserName: String?
    var title: String?
    var content: String?
    var createTime: TimeInterval?
}
