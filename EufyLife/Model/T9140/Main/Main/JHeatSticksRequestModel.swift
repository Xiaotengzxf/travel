//
//  JHeatSticksRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHeatSticksRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    
    override func url() -> String {
        return super.url() + "flavor/heatsticks"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        return header
    }
}
