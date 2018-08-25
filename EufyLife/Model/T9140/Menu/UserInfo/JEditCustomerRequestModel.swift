//
//  JEditCustomerRequestModel.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JEditCustomerRequestModel: JBaseRequestModel {
    
    private var token = JUserManager.sharedInstance.user?.access_token ?? ""
    private var uid = JUserManager.sharedInstance.user?.user_id ?? ""
    private var customer: Customer?
    
    init(customer: Customer) {
        super.init()
        self.customer = customer
    }
    
    override func url() -> String {
        return super.url() + "user/customer"
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["token"] = token
        header["uid"] = uid
        return header
    }
    
    override func toBody() -> [String : Any] {
        var body : [String : Any] = [:]
        body["Avatar"] = customer?.avatar ?? ""
        body["Birthday"] = customer?.birthday ?? 0
        body["CreateTime"] = 0
        body["CustomerNo"] = customer?.customer_no ?? 0
        body["Default"] = customer?.defaultValue ?? false
        body["Height"] = customer?.height ?? 0
        body["Id"] = customer?.id ?? ""
        body["Index"] = customer?.index ?? 0
        body["Name"] = customer?.name ?? ""
        body["Sex"] = customer?.sex ?? ""
        body["TargetWeight"] = customer?.target_weight ?? 0
        body["UpdateTime"] = 0
        body["UserId"] = JUserManager.sharedInstance.user?.user_id
        return body
    }
}
