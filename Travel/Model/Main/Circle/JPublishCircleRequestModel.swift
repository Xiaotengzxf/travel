//
//  JPublishCircleRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/15.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JPublishCircleRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/activity"
    }
    
}

class JGetActionRequestModel: JBaseRequestModel {
    
    private var activityId = ""
    
    init(activityId: String) {
        super.init()
        self.activityId = activityId
    }
    
    override func url() -> String {
        return super.url() + "api/activity/\(activityId)"
    }
    
}
