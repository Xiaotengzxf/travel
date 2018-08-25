//
//  JDeviceBindResponseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/5/11.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JDeviceBindResponseModel: Codable {
    
    var res_code : Int?
    var message : String?
    var device: JDeviceModel?
    
}
