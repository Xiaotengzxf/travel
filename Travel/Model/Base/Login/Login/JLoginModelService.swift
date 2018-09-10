//
//  JLoginModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginModelService: NSObject {
    
    func login(mobilePhone: String, password: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JLoginRequestModel(mobilePhone: mobilePhone, password: password)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        UserDefaults.standard.set(mobilePhone, forKey: kPhone)
                        JUserManager.sharedInstance.user = model?.data
                        JUserManager.sharedInstance.saveUserAccount(complete: true)
                        callback(true, nil)
                    } else {
                        callback(false, model?.errMsg)
                    }
                } else {
                    callback(false, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "网络异常，请检查网络")
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
}

