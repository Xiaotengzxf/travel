//
//  JAddCustomerResponseModel.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JAddCustomerResponseModel: Codable {
    var res_code = 0
    var message: String?
    var customer: Customer?
}
