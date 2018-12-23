//
//  JMyPhotoDetailModelService.swift
//  Travel
//
//  Created by ANKER on 2018/12/23.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JMyPhotoDetailModelService: NSObject {
    func deleteMyPhoto(photoId: String, callback: @escaping (Bool, String?)->()) {
        let request = JMyPhotoDetailRequsetModel(photoId: photoId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "DELETE", parameters: nil, headers: request.toHeader()) {
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

class JMyPhotoDetailRequsetModel: JBaseRequestModel {
    
    private var photoId: String?
    
    init(photoId: String) {
        super.init()
        self.photoId = photoId
    }
    
    override func url() -> String {
        return super.url() + "api/user-photo/\(photoId!)"
    }
}

