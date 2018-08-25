//
//  JFlavorUpdateRequestModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/7.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JFlavorUpdateRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var model: JFlavorUpdateModel?
    
    init(model : JFlavorUpdateModel) {
        super.init()
        self.model = model
    }
    
    override func url() -> String {
        return super.url() + "flavor/habbit/update"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        return header
    }
    
    override func toBody() -> [String : Any] {
        var body = super.toBody()
        if let sn = model?.device_sn {
            body["device_sn"] = sn
        }
        if let flavor_id = model?.flavor_id {
            body["flavor_id"] = flavor_id
        }
        body["flavor_level"] = model?.flavor_level ?? 0
        if let heatStick_id = model?.heatstick_id {
            body["heatstick_id"] = heatStick_id
        }
        
        return body
    }
}
