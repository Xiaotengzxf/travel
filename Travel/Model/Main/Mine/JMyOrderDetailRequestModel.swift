//
//  JMyOrderDetailRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyOrderDetailRequestModel: JBaseRequestModel {
    private var orderId: String!
    
    init(orderId: String) {
        super.init()
        self.orderId = orderId
    }
    
    override func url() -> String {
        return super.url() + "api/orders/\(orderId!)"
    }
    
    override func toBody() -> [String : Any] {
        return ["payStatus" : "cancle"]
    }
}
