//
//  JCircleModelService.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCircleModelService: NSObject {
    func getCircleList(callback: @escaping ([Circle]?, String?)->()) {
        let request = JJoinedCircleListRequestModel()
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
    
    func createCircle(circle: Circle, callback: @escaping (Bool, String?) -> ()) {
        let request = JCreateCircleRequestModel(circle: circle)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
                    if model != nil {
                        if model?.errCode == 0 {
                            callback(true, nil)
                        } else {
                            callback(false, model?.errMsg)
                        }
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                } else {
                    callback(false, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)")
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func circelJoin(circleId: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JCircleJoinRequestModel(circleId: circleId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JCircleJoinResponseModel.self, from: data)
                    if model != nil {
                        if model?.errCode == 0 {
                            callback(true, nil)
                        } else {
                            callback(false, model?.errMsg)
                        }
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                } else {
                    callback(false, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)")
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func uploadHeaderIcon(imageData: Data, callback: @escaping (Bool, String?) -> ()) {
        let request = JIconUploadRequestModel()
        let network = ZNetwork()
        network.upload(data: imageData, url: request.url(), queue: DispatchQueue.global()) {
            (result, url) in
            callback(result, url)
        }
    }
}
