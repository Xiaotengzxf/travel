//
//  JDeviceDataResponseModel.swift
//  Jouz
//
//  Created by doubll on 2018/5/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

struct JDeviceDataResponseModel: Codable {
    var res_code : Int?
    var message : String?
    var devices: [JDeviceModel] = []
}
