//
//  SCWelcomeRequestModel.swift
//  SoundCore
//
//  Created by ANKER on 2018/5/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCWelcomeRequestModel: JBaseRequestModel {

    override func url() -> String {
        let time = UserDefaults.standard.integer(forKey: kPolicyKey)
        return super.url() + "help/data_policy?last_time=\(time > 0 ? "\(time)" : "")"
    }
    
}
