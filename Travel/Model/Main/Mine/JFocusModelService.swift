//
//  JFocusModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/17.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JFocusModelService: NSObject {
    
    func getFocus(page: Int, keyboard: String?, criteria: String?, orderby: String?, callback: @escaping ([Fan]?, String?)->())  {
        let request = JMyFocusRequestModel(pageNum: page, criteria: criteria ?? "", keyword: keyboard ?? "", orderBy: orderby ?? "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: request.toBody(), headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(FanModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(model?.data, nil)
                    } else {
                        callback(nil, model?.errMsg)
                    }
                } else {
                    callback(nil, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(nil, "\(kErrorNetworkOffline)")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func getFan(page: Int, keyboard: String?, criteria: String?, orderby: String?, callback: @escaping ([Fan]?, String?)->())  {
        let request = JMyFanRequestModel(pageNum: page, criteria: criteria ?? "", keyword: keyboard ?? "", orderBy: orderby ?? "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: request.toBody(), headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(FanModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(model?.data, nil)
                    } else {
                        callback(nil, model?.errMsg)
                    }
                } else {
                    callback(nil, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(nil, "\(kErrorNetworkOffline)")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
}

class Fan: Codable {
    var createTime: Int?
    var fansNumber: Int?
    var focusNumber: Int?
    var focusUserId: String?
    var focusUserName: String?
    var id: String?
    var memoName: String?
    var origin: String?
    var status: String?
    var type: String?
    var user: User?
    var userId: String?
    var userName: String?
}

class FanModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: [Fan]?
}
