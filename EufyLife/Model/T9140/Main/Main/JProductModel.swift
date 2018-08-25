//
//  JProduct.swift
//  Jouz
//
//  Created by ANKER on 2018/5/11.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

struct JProductModel: Codable {
    var create_time = 0
    var desc : String?
    var icon_url : String?
    var name : String?
    var product_code : String?
    var seq = 0
    var update_time = 0
    var uuid: String?
    
    enum CodingKeys: String, CodingKey {
        case create_time
        case desc = "description"
        case icon_url
        case name
        case product_code
        case seq
        case update_time
        case uuid
    }
}
