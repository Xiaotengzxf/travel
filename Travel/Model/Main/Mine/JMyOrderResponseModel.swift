//
//  JMyOrderResponseModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyOrderResponseModel: Codable {
    var data: [Order]?
    var errCode: Int?
    var errMsg: String?
}

class Order: Codable {
    var activityEnterContactList : [ActivityEnterContact]?
    var activityEnterId : String?
    var activityEnterName : String?
    var activityId : String?
    var activityName : String?
    var circleId : String?
    var createTime: TimeInterval?
    var deleted : String?
    var description : String?
    var id : String?
    var mobilePhone : String?
    var name : String?
    var number : String?
    var payStatus : String?
    var payTime : TimeInterval?
    var payType : String?
    var people : Int?
    var realName : String?
    var refundNumber : String?
    var remark : String?
    var status : String?
    var totalFee : Float?
    var type : String?
    var updateTime : TimeInterval?
    var userId : String?
    var userName : String?
    var activity: Activity?
}

class ActivityEnterContact: Codable {
    var id : String?
    var activityId : String?
    var activityEnterId : String?
    var realName : String?
    var gender : String?
    var idCardNumber : String?
    var mobilePhone : String?
    var type : String?
    var status : String?
    var userType : String?
    var createTime : TimeInterval?
    var activityName : String?
    var activityEnterName : String?
}
