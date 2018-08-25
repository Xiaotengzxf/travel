//
//  JDeviceModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/11.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

struct JDeviceModel: Codable {
    var alias_name: String?
    var bt_ble_mac: String?
    var create_time = 0
    var hardware_version: String?
    var product: JProductModel?
    var product_code: String?
    var sn: String?
    var software_version: String?
    var software_version_time = 0
    var update_time = 0
    var user_id: String?
    var uuid: String?
}
