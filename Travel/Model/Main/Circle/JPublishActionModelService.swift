//
//  JPublishActionModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JPublishActionModelService: NSObject {
    
    func publishCircle(value: [String : Any], callback: @escaping (Bool, String?) -> ()) {
        let request = JPublishCircleRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: value, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(true, "发布活动成功")
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
    
    func favoriteCircle(activityId: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JFavoriteActionRequestModel(activityId: activityId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
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
    
    func unfavoriteCircle(activityId: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JUNFavoriteActionRequestModel(activityId: activityId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "DELETE", parameters: nil, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
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
    
    func getActionDetail(activityId: String, callback: @escaping (Activity?, String?) -> ()) {
        let request = JGetActionRequestModel(activityId: activityId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(ActivityDetailModel.self, from: data)
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
