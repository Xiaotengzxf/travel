//
//  JCircleJoinRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCircleJoinRequestModel: JBaseRequestModel {
    
    private var circleId: String = ""
    
    init(circleId: String) {
        super.init()
        self.circleId = circleId
    }
    
    override func url() -> String {
        return super.url() + "api/circle-join"
    }
    
    override func toBody() -> [String : Any] {
        return ["circleId": circleId]
    }
}
