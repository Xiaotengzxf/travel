//
//  JPublishCircleModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/14.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JPublishCircleModelService: NSObject {
    
    func uploadHeaderIcon(imageData: Data, callback: @escaping (Bool, String?) -> ()) {
        let request = JIconUploadRequestModel()
        let network = ZNetwork()
        network.upload(data: imageData, url: request.url(), queue: DispatchQueue.global()) {
            (result, url) in
            callback(result, url)
        }
    }
    
    func downloadAllCircle(callback: @escaping ([Circle]?, String?) -> ()) {
        let request = JMyCircleRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JCircleListResponseModel.self, from: data)
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
