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
            
        }
    }
    
    func uploadHeaderIcon(imageData: Data) {
        let request = JIconUploadRequestModel()
        let network = ZNetwork()
        network.upload(data: imageData, url: request.url(), queue: DispatchQueue.global()){
            (result, url) in
            
        }
    }
}
