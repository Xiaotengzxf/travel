//
//  JRecommendHeatSticksResponseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/7.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRecommendHeatSticksResponseModel: Codable {
    var res_code : Int?
    var message : String?
    var flavors : [String : Flavor]?
    var flavor_recommends : [Recommend]?
}

class Recommend: Codable {
    var flavor_id : String?
    var heatstick_id : String?
    var name : String?
    var side_brand_id : String?
}
