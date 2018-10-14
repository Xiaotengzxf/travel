//
//  JMyOrderModelService.swift
//  Travel
//
//  Created by ANKER on 2018/12/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyOrderModelService: NSObject {
    
    private func indexToType(index: Int) -> String {
        switch index {
        case 0:
            return ""
        case 1:
            return "unpaid"
        default:
            return ""
        }
    }
    
    func getMyOrderList(index: Int, callback: @escaping ([Order]?, String?) -> ()) {
        let type = indexToType(index: index)
        let request = JMyOrderRequestModel(status: type)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JMyOrderResponseModel.self, from: data)
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
    
    func cancelOrder(orderId: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JMyOrderDetailRequestModel(orderId: orderId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), headers: request.toHeader()) {
            (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
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
