//
//  JPayRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JPayRequestModel: JBaseRequestModel {
    private var orderNo: String!
    private var isWX = false
    
    init(orderNo: String, isWX: Bool) {
        super.init()
        self.orderNo = orderNo
        self.isWX = isWX
    }
    
    override func url() -> String {
        if isWX {
            return super.url() + "api/wx-pay-order"
        } else {
            return super.url() + "api/ali-pay-order"
        }
    }
    
    override func toBody() -> [String : Any] {
        if isWX {
            return ["outTradeNo": orderNo!]
        }
        return ["number": orderNo!]
    }
}

class JPayResponseModel: Codable {
    
    var errCode : Int?
    var errMsg : String?
    var data: String?
    
}

class JWXPayResponseModel: Codable {
    
    var errCode : Int?
    var errMsg : String?
    var data: WXPayModel?
    
}


class WXPayModel: Codable {
    var appId : String?
    var nonceStr : String?
    var packageValue : String?
    var partnerId : String?
    var prepayId : String?
    var sign : String?
    var timeStamp : String?
}
