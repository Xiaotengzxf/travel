//
//  JCommonContactModelService.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCommonContactModelService: NSObject {
    
    func getContactList(type: String?, callback: @escaping ([JCommonContactModel]?, String?)->()) {
        let request = JCommonContactRquestModel(type: type)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JCommonContactResponseModel.self, from: data)
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
