//
//  JRefreshTokenRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/6.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRefreshTokenRequestModel: JBaseRequestModel {
    
    private var refreshToken = ""
    
    init(refreshToken: String) {
        super.init()
        self.refreshToken = refreshToken
    }
    
    override func url() -> String {
        return super.url() + "user/refresh_token"
    }
    
    override func toBody() -> [String : Any] {
        var body = super.toBody()
        body["refresh_token"] = refreshToken
        return body
    }
}
