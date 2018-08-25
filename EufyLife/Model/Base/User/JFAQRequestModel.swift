//
//  JFAQRequestModel.swift
//  Jouz
//
//  Created by doubll on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JFAQRequestModel: JBaseRequestModel {
    private var productCode: String = ""
    
    init(productCode: String) {
        super.init()
        self.productCode = productCode
    }
    
    override func url() -> String {
        let url = productCode.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return super.url() + "help/faq/\(url)"
    }
}

struct JFAQResponseModel: Codable {
    var res_code: Int = 0
    var message: String?
    var data: [JFAQResponseObj]?
}


struct JFAQResponseObj: Codable{
    var id: String?
    var seq: Int
    var question: String?
    var answer: String?
}
