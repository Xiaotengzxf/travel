//
//  JMyFavoriteRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyFavoriteRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/user-favorite"
    }
}

class JActivityRequestModel: JBaseRequestModel {
    
    private var id = ""
    
    init(id: String) {
        super.init()
        self.id = id
    }
    
    override func url() -> String {
        let url = "api/activity?criteria={\"circleId\":\"\(id)\"}"
        let urlB = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlC = urlB.replacingOccurrences(of: ":", with: "%3A")
        return super.url() + urlC
    }
}

class ActivityGather: Codable {
    var activityId : String?
    var activityName : String?
    var addressDetail : String?
    var circleId : String?
    var circleName : String?
    var city : String?
    var createTime : TimeInterval?
    var description : String?
    var district : String?
    var id : String?
    var name : String?
    var province : String?
    var sortIndex : Int?
    var status : String?
    var time : String?
    var type : String?
}

class ActivityInfo: Codable {
    var activityId : String?
    var activityName : String?
    var circleId : String?
    var circleName : String?
    var content : String?
    var createTime : TimeInterval?
    var id : String?
    var sortIndex : Int?
    var status : String?
    var title : String?
    var type : String?
}

class Activity: Codable {
    var activityGatherList: [ActivityGather]?
    var activityIds: [String]?
    var activityInfoList: [ActivityInfo]?
    var addressDetail : String?
    var circleId : String?
    var circleIdList : [String]?
    var circleName : String?
    var city : String?
    var content : String?
    var createTime : TimeInterval?
    var depositAmount : Float?
    var description : String?
    var district : String?
    //var endDate : TimeInterval?
    var endTime : String?
    //var endTimes : TimeInterval?
    //var enterDeadDate : TimeInterval?
    //var enterDeadTimes : TimeInterval?
    var enterDeadline : String?
    var enterMaxNumber : Int?
    var enteredNumber : Int?
    var fee : Float?
    var feeChild : Float?
    var feeElder : Float?
    var id : String?
    var imageUrl : String?
    var isFavorite : Bool?
    var isOriginalCircle : Bool?
    var name : String?
    var payType : String?
    var province : String?
    //var startDate : TimeInterval?
    var startTime : String?
    //var startTimes : TimeInterval?
    var status : String?
    var subTitle : String?
    var title : String?
    var type : String?
}

class ActivityModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: [Activity]?
}

class ActivityDetailModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: Activity?
}

class ActivityB: Codable {
    var activity: Activity?
    var activityId: String?
    var activityName: String?
    var createTime: TimeInterval?
    var id: String?
    var ids: String?
    var origin: String?
    var remark: String?
    var status: String?
    var type: String?
    var userId: String?
    var userName: String?
}

class ActivityFavoriteModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: [ActivityB]?
}
