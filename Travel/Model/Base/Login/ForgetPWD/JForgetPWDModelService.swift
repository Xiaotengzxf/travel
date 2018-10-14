//
//  JForgetPWDModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDModelService: NSObject {
    func forgetPWD(phone: String, password: String, code: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JForgetPWDRequestModel(phone: phone, password: password, code: code)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data!)
                if model?.errCode == 0 {
                    callback(true, model?.errMsg)
                } else {
                    callback(false, model?.errMsg)
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "无法连接网络，请检查网络")
                    } else {
                        callback(false, "服务器异常，请检查网络")
                    }
                }
            }
        }
    }
    
    func getToken(mobilePhone: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JTokenRequestModel(mobilePhone: mobilePhone)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) { (response, error) in
            if let value = response {
                let data = value.data(using: .utf8)
                let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data!)
                if model?.errCode == 0 {
                    callback(true, model?.errMsg)
                } else {
                    callback(false, model?.errMsg)
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "无法连接网络，请检查网络")
                    } else {
                        callback(false, "服务器异常，请检查网络")
                    }
                }
            }
        }
    }
}
