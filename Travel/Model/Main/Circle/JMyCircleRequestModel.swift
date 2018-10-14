//
//  JMyCircleRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/11/15.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyCircleRequestModel: JBaseRequestModel {
    
    override func url() -> String {
        return super.url() + "api/my-circle"
    }

}
