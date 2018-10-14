//
//  JApplyActionRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/2.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JApplyActionRequestModel: JBaseRequestModel {
    
    private var activityContent: [String : Any] = [:]
    
    init(activityContent: [String : Any]) {
        super.init()
        self.activityContent = activityContent
    }
    
    override func url() -> String {
        return super.url() + "/api/activity-enter"
    }
    
    override func toBody() -> [String : Any] {
        return activityContent
    }
}
