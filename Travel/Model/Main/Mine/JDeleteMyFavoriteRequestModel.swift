//
//  JDeleteMyFavoriteRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JDeleteMyFavoriteRequestModel: JBaseRequestModel {
    private var id = ""
    
    init(id: String) {
        super.init()
        self.id = id
    }
    
    override func url() -> String {
        return super.url() + "api/user-favorite/\(id)"
    }
}
