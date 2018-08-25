//
//  JProductListRequestModel.swift
//  Jouz
//
//  Created by doubll on 2018/5/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

///查询当前用户拥有的设备
class JDeviceDataRequestModel: JBaseRequestModel {
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""

    override func url() -> String {
       return super.url() + "device/"
    }

    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }
}
