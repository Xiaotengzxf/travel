//
//  JCreateCircleRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/5.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCreateCircleRequestModel: JBaseRequestModel {
    
    private var circle: Circle?
    
    init(circle: Circle) {
        super.init()
        self.circle = circle
    }
    
    override func url() -> String {
        return super.url() + "api/circle"
    }
    
    override func toBody() -> [String : Any] {
        var body : [String : Any] = [:]
        body["type"] = circle?.type ?? ""
        //body["createUserId"] = JUserManager.sharedInstance.user?.userId ?? ""
        //body["createUserName"] = JUserManager.sharedInstance.user?.userName ?? ""
        body["name"] = circle?.name ?? ""
        body["description"] = circle?.description ?? ""
        if let imageUrl = circle?.imageUrl {
            body["imageUrl"] = imageUrl
        }
        //body["createTime"] = "2018-11-05T05:36:37.986Z"
        return body
    }
}
