//
//  JSignUpModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSignUpModelService: NSObject {
    
    func signUp(mobilePhone: String, password: String, code: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JRegisterRequestModel(mobilePhone: mobilePhone, password: password, code: code)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (response, error) in
            if let value = response {
                let data = value.data(using: .utf8)
                let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data!)
                if model?.errCode == 1 {
                    UserDefaults.standard.set(mobilePhone, forKey: kPhone)
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
    
    private func registerEM() {
        let error = EMClient.shared()?.register(withUsername: "15818751003", password: "111111")
        if error == nil  {
            print("注册成功")
        }
    }
}
