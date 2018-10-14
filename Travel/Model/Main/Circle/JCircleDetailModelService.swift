//
//  JCircleDetailModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCircleDetailModelService: NSObject {
    func getCircleDetail(id: String, callback: @escaping (Circle?, String?) -> ()) {
        let request = JCircleDetailRequsetModel(circleId: id)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JCircleDetailResponseModel.self, from: data)
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

class JCircleDetailRequsetModel: JBaseRequestModel {
    
    private var circleId: String = ""
    
    init(circleId: String) {
        super.init()
        self.circleId = circleId
    }
    
    override func url() -> String {
        return super.url() + "api/circle/\(circleId)"
    }
    
}

class JCircleDetailResponseModel: Codable {
    var errCode = 0
    var errMsg: String?
    var data: Circle?
}
