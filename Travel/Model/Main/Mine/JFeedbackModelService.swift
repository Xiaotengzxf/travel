//
//  JFeedbackModelService.swift
//  Travel
//
//  Created by ANKER on 2018/11/18.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JFeedbackModelService: NSObject {
    
    func feedback(content: String, mobilePhone: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JFeedbackRequestModel(content: content, mobilePhone: mobilePhone)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) {
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

class JFeedbackRequestModel: JBaseRequestModel {
    
    private var content: String = ""
    private var mobilePhone: String = ""
    
    init(content: String, mobilePhone: String) {
        super.init()
        self.content = content
        self.mobilePhone = mobilePhone
    }
    
    override func url() -> String {
        return super.url() + "api/feed-back"
    }
    
    override func toBody() -> [String : Any] {
        return ["content": content, "mobilePhone" : mobilePhone]
    }
}
