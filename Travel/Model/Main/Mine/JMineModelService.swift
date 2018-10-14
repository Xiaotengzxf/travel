//
//  JMineRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMineModelService: NSObject {
    func getUserInfo(callback: @escaping (Bool, String?) -> ()) {
        let request = JLoginUserInfoRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {(response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(LoginUserInfoModel.self, from: data)
                    UserDefaults.standard.set(value, forKey: "loginUserInfo")
                    UserDefaults.standard.synchronize()
                    if model?.errCode == 0 {
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
