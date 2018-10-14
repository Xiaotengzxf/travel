//
//  JLastMessageRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/15.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JLastMessageRequestModel: JBaseRequestModel {
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
        return super.url() + "api/message-last-page"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["Authorization"] = JUserManager.sharedInstance.user?.token ?? ""
        return header
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
