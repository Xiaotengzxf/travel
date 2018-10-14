//
//  JContactRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/18.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JContactRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/settings"
    }
}
