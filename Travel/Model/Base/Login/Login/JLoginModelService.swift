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
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        JUserManager.sharedInstance.user = model?.data
                        JUserManager.sharedInstance.saveUserAccount(complete: true)
                        self?.getUserInfo(callback: callback)
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
    
    private func loginEM(userName: String, password: String, callback: @escaping (Bool, String?) -> ()) {
         EMClient.shared()?.login(withUsername: userName, password: password, completion: { (name, err) in
            if err == nil {
                UserDefaults.standard.set(userName, forKey: kPhone)
                UserDefaults.standard.synchronize()
                EMClient.shared()?.options.isAutoLogin = true // 自动登录开启
                print("[EM] 登录成功")
                callback(true, nil)
            } else {
                print("[EM] \(err!.code)")
                callback(true, nil)
            }
            EMClient.shared()
        })
    }
    
    
    private func getUserInfo(callback: @escaping (Bool, String?) -> ()) {
        let request = JLoginUserInfoRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {[weak self] (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(LoginUserInfoModel.self, from: data)
                    UserDefaults.standard.set(value, forKey: "loginUserInfo")
                    UserDefaults.standard.synchronize()
                    if model?.errCode == 0 {
                        self?.loginEM(userName: model?.data?.chatId ?? "", password: model?.data?.password ?? "", callback: callback)
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

