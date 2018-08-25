//
//  JBindDeviceRequest.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JBindDeviceRequestModel: JBaseRequestModel {
    private var macAddress: [String] = []
    
    init(macAddress: [String]) {
        super.init()
        self.macAddress = macAddress
    }
    
    override func url() -> String {
        return super.url() + "device/mul"
    }
    
    override func toHeader() -> [String : String] {
        var dic = super.toHeader()
        dic["token"] = JUserManager.sharedInstance.user?.access_token ?? ""
        dic["uid"] = JUserManager.sharedInstance.user?.user_id ?? ""
        return dic
    }
    
    override func toBody() -> [String : Any] {
        var dic : [String: Any] = [:]
        dic["mac_address"] = macAddress
        return dic
    }
}
