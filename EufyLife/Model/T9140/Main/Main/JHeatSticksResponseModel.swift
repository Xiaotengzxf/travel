//
//  JHeatSticksResponseModel.swift
//  Jouz
//
//  Created by ANKER on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHeatSticksResponseModel: Codable {
    var res_code : Int?
    var message : String?
    var flavors : [String : Flavor]?
    var last_heatstick_id : String?
    var last_side_brand_id : String?
    var side_brands : [SideBrand]?
}


class Flavor: Codable {
    var uuid : String?
    var low : [Int]?
    var medium : [Int]?
    var high : [Int]?
}

class Heatstick: Codable {
    var uuid : String?
    var name : String?
    var description : String?
    var counter : Int?
    var flavor_id : String?
    var level : Int?
    var pictures : String?
    var lang : [String : String]?
}

class SideBrand: Codable {
    var uuid : String?
    var name : String?
    var description : String?
    var counter : Int?
    var heatsticks : [Heatstick]?
    var lang : [String : String]?
}
