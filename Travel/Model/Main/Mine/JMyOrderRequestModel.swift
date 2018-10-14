//
//  JMyOrderRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyOrderRequestModel: JBaseRequestModel {
    
    private var status: String!
    
    init(status: String) {
        super.init()
        self.status = status
    }
    
    override func url() -> String {
        if status.count == 0 {
            return super.url() + "api/orders"
        } else {
            let url = "api/orders?criteria={\"payStatus\":\"\(status!)\"}"
            let urlB = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlC = urlB.replacingOccurrences(of: ":", with: "%3A")
            return super.url() + urlC
        }
    }
}
