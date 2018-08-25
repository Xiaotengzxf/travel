//
//  JAddCustomerRequestModel.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JAddCustomerRequestModel: JBaseRequestModel {
    
    private var age = 0
    private var height = 0
    private var name = ""
    private var sex = ""
    
    init(name: String, sex: String, age: Int, height: Int) {
        super.init()
        self.name = name
        self.sex = sex
        self.age = age
        self.height = height
    }
    
    override func url() -> String {
        return super.url() + "user/customer"
    }
    
    override func toHeader() -> [String : String] {
        return ["token" : JUserManager.sharedInstance.user?.access_token ?? "",
                "uid" : JUserManager.sharedInstance.user?.user_id ?? ""]
    }
    
    override func toBody() -> [String : Any] {
        var dic = super.toBody()
        dic["name"] = name
        dic["sex"] = sex
        dic["birthday"] = age
        dic["height"] = height
        return dic
    }
}
