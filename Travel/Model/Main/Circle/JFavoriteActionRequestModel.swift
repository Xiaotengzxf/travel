//
//  JFavoriteActionRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/21.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JFavoriteActionRequestModel: JBaseRequestModel {
    
    private var activityId: String = ""
    
    init(activityId: String) {
        super.init()
        self.activityId = activityId
    }
    
    override func url() -> String {
        return super.url() + "/api/user-favorite"
    }
    
    override func toBody() -> [String : Any] {
        return ["activityId": activityId]
    }
}

class JUNFavoriteActionRequestModel: JBaseRequestModel {
    
    private var activityId: String = ""
    
    init(activityId: String) {
        super.init()
        self.activityId = activityId
    }
    
    override func url() -> String {
        return super.url() + "/api/user-favorite/\(activityId)"
    }
    
}
