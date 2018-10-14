//
//  JMyPhotoRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyPhotoRequestModel: JBaseRequestModel {
    private var pageNum = 0
    private let pageSize = 20
    private var criteria = ""
    private var keyword = ""
    private var orderBy = ""
    
    init(pageNum: Int,
         criteria: String,
         keyword: String,
         orderBy: String) {
        super.init()
        self.pageNum = pageNum
        self.criteria = criteria
        self.keyword = keyword
        self.orderBy = orderBy
    }
    
    override func url() -> String {
        return super.url() + "api/user-photo"
    }
    
    override func toBody() -> [String : Any] {
        var body : [String : Any] = [:]
        body["pageNum"] = pageNum
        body["pageSize"] = pageSize
        if criteria.count > 0 {
            body["criteria"] = criteria
        }
        if keyword.count > 0 {
            body["keyword"] = keyword
        }
        if orderBy.count > 0 {
            body["orderBy"] = orderBy
        }
        return body
    }
}

class JMyPhotoResponseModel: Codable {
    //var 
}

class MyPhotoModel: Codable {
    var createTime: TimeInterval?
    var id: String?
    var imageUrl: String?
    var remark: String?
    var status: String?
    var type: String?
    var userId: String?
    var userName: String?
}
