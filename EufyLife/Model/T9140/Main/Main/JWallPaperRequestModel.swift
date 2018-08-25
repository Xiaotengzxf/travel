//
//  JWallPaperRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/4.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JWallPaperRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    
    override func url() -> String {
        return super.url() + "device/backgroud"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }
}
