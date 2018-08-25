//
//  JSignUpModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSignUpModelService: NSObject {
    
    weak var presenter: JSignUpPresenterDelegate?
    
    init(presenter: JSignUpPresenterDelegate) {
        super.init()
        self.presenter = presenter
    }
}

extension JSignUpModelService: JSignUpModelServiceDelegate {
    
    func signUp(email: String, password: String, name: String, isSubscribe: Bool, callback: @escaping (Bool, String?) -> ()) {
        let request = JRegisterRequestModel(email: email, password: password, nickName: name, isSubscribe: isSubscribe)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (value, error) in
            if let response = value {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data!)
                if model?.res_code == 1 {
                    UserDefaults.standard.set(email, forKey: kEmail)
                    JUserManager.sharedInstance.user = model?.responseToUser()
                    JUserManager.sharedInstance.saveUserAccount(complete: false)
                    callback(true, model?.message)
                } else {
                    callback(false, model?.message)
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)")
                    } else {
                        callback(false, nil)
                    }
                }
            }
        }
    }
}
