//
//  JAccountSettingsModelService.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JAccountSettingsModelService: NSObject {
    func updateAccount(icon: String?, userName: String?, phone: String?, introduce: String?, callback: @escaping (Bool, String?)->()) {
        let request = JAccountSettingsRequestModel(introduce: introduce ?? "", mobilePhone: phone ?? "", userName: userName ?? "", imageUrl: icon ?? "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        let userInfo = UserDefaults.standard.object(forKey: "loginUserInfo") as? String ?? ""
                        if let data = userInfo.data(using: .utf8) {
                            let model = try? JSONDecoder().decode(LoginUserInfoModel.self, from: data as Data)
                            model?.data?.userName = userName
                            model?.data?.introduce = introduce
                            model?.data?.mobilePhone = phone
                            model?.data?.icon = icon
                            if let d = try? JSONEncoder().encode(model) {
                                let info = String(data: d, encoding: String.Encoding.utf8)
                                UserDefaults.standard.set(info, forKey: "loginUserInfo")
                                UserDefaults.standard.synchronize()
                            }
                        }
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
    
    func uploadHeaderIcon(imageData: Data, callback: @escaping (Bool, String?) -> ()) {
        let request = JIconUploadRequestModel()
        let network = ZNetwork()
        network.upload(data: imageData, url: request.url(), queue: DispatchQueue.global()) {
            (result, url) in
            print("上传图片回调结果：\(String(describing: url))")
            callback(result, url)
        }
    }
    
    func rpbasic(callback: @escaping (JRPBasic?, String?)->()) {
        let request = JRPBasicRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: nil, headers: request.toHeader()) { (response, error) in
            if let value = response?.replacingOccurrences(of: "\n", with: "") {
                if let data = value.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JRPBasicResponseModel.self, from: data)
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
