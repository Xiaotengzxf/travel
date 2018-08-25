//
//  JDeleteCustomerRequestModel.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JDeleteCustomerRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    private var customerId: String?
    
    init(customerId: String) {
        super.init()
        self.customerId = customerId
    }
    
    override func url() -> String {
        return super.url() + "user/customer/\(customerId ?? "")"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }
    
}
