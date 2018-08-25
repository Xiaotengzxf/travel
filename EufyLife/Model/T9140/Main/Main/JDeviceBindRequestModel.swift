//
//  JDeviceBindRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/11.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JDeviceBindRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    private var deviceModel: JDeviceModel?
    
    init(model: JDeviceModel) {
        super.init()
        deviceModel = model
    }
    
    override func url() -> String {
        return super.url() + "device/"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }
    
    override func toBody() -> [String : Any] {
        var body = super.toBody()
        if let aliasName = deviceModel?.alias_name {
            body["alias_name"] = aliasName
        }
        if let btBleMac = deviceModel?.bt_ble_mac {
            body["bt_ble_mac"] = btBleMac
        }
        if let deviceSn = deviceModel?.sn {
            body["device_sn"] = deviceSn
        }
        if let hardwareVersion = deviceModel?.hardware_version {
            body["hardware_version"] = hardwareVersion
        }
        if let productCode = deviceModel?.product_code {
            body["product_code"] = productCode
        }
        if let softwareVersion = deviceModel?.software_version {
            body["software_version"] = softwareVersion
        }
        body["software_version_time"] = deviceModel?.software_version_time ?? 0
        
        return body
    }
}
