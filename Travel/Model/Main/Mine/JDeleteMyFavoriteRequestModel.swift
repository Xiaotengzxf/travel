//
//  JDeleteMyFavoriteRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JDeleteMyFavoriteRequestModel: JBaseRequestModel {
    private var ids: [String] = []
    
    init(ids: [String]) {
        super.init()
        self.ids = ids
    }
    
    override func url() -> String {
        return super.url() + "api/user-favorite-delete-batch"
    }
    
    override func toBody() -> [String : Any] {
        return ["ids": ids]
    }
}
