//
//  JTempCircleRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/20.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JTempCircleRequestModel: JBaseRequestModel {
    override func url() -> String {
        return super.url() + "api/my-join-temporary-circle"
    }
}
