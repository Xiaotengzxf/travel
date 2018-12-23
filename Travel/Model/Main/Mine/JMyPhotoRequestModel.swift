//
//  JMyPhotoRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyPhotoRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/user-photo"
    }
    
}

class JPhotoRequestModel: JBaseRequestModel {
    
    private var urlStr: String?
    
    init(urlStr: String) {
        super.init()
        self.urlStr = urlStr
    }
    
    override func url() -> String {
        return super.url() + "api/user-photo"
    }
    
    override func toBody() -> [String : Any] {
        return ["imageUrl" : urlStr!]
    }
}

class JMyPhotoResponseModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: [MyPhotoModel]?
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
