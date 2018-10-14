//
//  JAddCommonContactRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JAddCommonContactRequestModel: JBaseRequestModel {
    
    private var model: JCommonContactModel!
    
    init(model: JCommonContactModel) {
        super.init()
        self.model = model
    }
    
    
    override func url() -> String {
        return super.url() + "api/contact"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["Authorization"] = JUserManager.sharedInstance.user?.token ?? ""
        return header
    }
    
    // // {"type":"child","idCardNumber":"320923198801164656","mobilePhone":"15914177430","realName":"看看"}
    override func toBody() -> [String : Any] {
        var body : [String : Any] = [:]
        body["type"] = model.type ?? ""
        body["idCardNumber"] = model.idCardNumber ?? ""
        body["mobilePhone"] = model.mobilePhone ?? ""
        body["realName"] = model.realName ?? ""
        return body
    }
}
