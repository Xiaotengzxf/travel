//
//  JLoginModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginModelService: NSObject {
    
    func login(email: String, password: String, callback: @escaping (Bool, String?, Bool) -> ()) {
        let request = JLoginRequestModel(email: email, password: password)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data)
                    if model?.res_code == 1 {
                        UserDefaults.standard.set(email, forKey: kEmail)
                        JUserManager.sharedInstance.user = model?.responseToUser()
                        let complete = model?.customers?.count ?? 0 > 0
                        JUserManager.sharedInstance.saveUserAccount(complete: complete)
                        callback(true, nil, complete)
                    } else {
                        callback(false, model?.message, false)
                    }
                } else {
                    print("登录时，服务器有异常")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)", false)
                    } else {
                        callback(false, nil, false)
                    }
                }
            }
        }
    }
    
}

