//
//  JApplyActionModelService.swift
//  Travel
//
//  Created by ANKER on 2018/12/2.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JApplyActionModelService: NSObject {
    
    func applyAction(content: [String : Any], callback: @escaping (Order?, String?) -> ()) {
        let request = JApplyActionRequestModel(activityContent: content)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JApplyActionResponseModel.self, from: data)
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
                        callback(nil, "网络异常，请检查网络")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
}

class JApplyActionResponseModel: Codable {
    var data: Order?
    var errCode: Int?
    var errMsg: String?
}
