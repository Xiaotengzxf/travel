//
//  JCommonContactResponseModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCommonContactResponseModel: Codable {
    var errCode = 0
    var errMsg: String?
    var data: [JCommonContactModel]?
}
