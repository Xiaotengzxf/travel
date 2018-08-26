//
//  JForgetPWDModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDModelService: NSObject {
    func forgetPWD(email: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JForgetPWDRequestModel(email: email)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data!)
                if model?.res_code == 1 {
                    callback(true, nil)
                } else {
                    callback(false, model?.message)
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)")
                    } else {
                        callback(false, nil)
                    }
                }
            }
        }
    }
}
