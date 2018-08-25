//
//  JBindDeviceResponseModel.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JBindDeviceResponseModel: Codable {
    var res_code = 0
    var message: String?
    var fails: [Fail]?
    var devices: [Device]?
}



class Fail: Codable {
    var id: String?
    var id_type: String?
    var error: String?
    var error_code = 0
}


