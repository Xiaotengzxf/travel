//
//  JContactModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/18.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JContactModelService: NSObject {
    
    func contact(callback: @escaping (String?, String?) -> ()) {
        let request = JContactRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(ContactModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(model?.data?.servicePhone ?? "", nil)
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
                        callback(nil, "网络有问题，请检查网络")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
        
    }
}

class Contact: Codable {
    var id: String?
    var serviceName: String?
    var servicePhone: String?
    var createTime: Int?
}

class ContactModel: Codable {
    var errCode: Int?
    var errMsg: String?
    var data: Contact?
}
