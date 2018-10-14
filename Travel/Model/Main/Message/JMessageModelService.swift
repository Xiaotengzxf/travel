//
//  JMessageModelService.swift
//  Travel
//
//  Created by ANKER on 2018/9/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMessageModelService: NSObject {
    func getMessageList(page: Int, keyboard: String?, criteria: String?, orderby: String?, callback: @escaping ([Message]?, String?)->()) {
        let request = JMessageListRequestModel(pageNum: page, criteria: criteria ?? "", keyword: keyboard ?? "", orderBy: orderby ?? "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: request.toBody(), headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JMessageListResponseModel.self, from: data)
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
                            callback(nil, "\(kErrorNetworkOffline)")
                        } else {
                            callback(nil, "服务器异常，请稍后重试")
                        }
                    }
                }
        }
    }
    
    func getLastMessage(callback: @escaping ([Message]?, String?)->()) {
        let request = JLastMessageRequestModel(pageNum: 0, criteria: "", keyword: "", orderBy: "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: request.toBody(), headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JMessageListResponseModel.self, from: data)
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
                        callback(nil, "\(kErrorNetworkOffline)")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func getCircleList(callback: @escaping ([Circle]?, String?)->()) {
        let request = JTempCircleRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JCircleListResponseModel.self, from: data)
                    if model != nil {
                        if model?.errCode == 0 {
                            callback(model?.data, nil)
                        } else {
                            callback(nil, model?.errMsg)
                        }
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                } else {
                    callback(nil, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(nil, "\(kErrorNetworkOffline)")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
}
