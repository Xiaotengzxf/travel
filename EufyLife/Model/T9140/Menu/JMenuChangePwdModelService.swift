//
//  JMenuChangePwdModelService.swift
//  Jouz
//
//  Created by doubll on 2018/6/1.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension JMenuChangePwdModelService: JMenuChangePwdModelServiceDelegate {
    func changePassword(oldPassword: String, newPassword: String) {
        let model = JUserChangePwdRequestModel()
        model.newPassword = newPassword
        model.oldPassword = oldPassword
        ZNetwork().request(strUrl: model.url(), strMethod: "POST", parameters: model.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: model.toHeader()) { (msg, error) in
            if let response = msg?.replacingOccurrences(of: "\n", with: "") {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JUserUpdateResponseModel.self, from: data!)
                self.presenter?.callback(passwordChanged: model?.res_code == 1, msg: model?.message)
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        self.presenter?.callback(passwordChanged: false, msg: "\(kErrorNetworkOffline)")
                    } else {
                        self.presenter?.callback(passwordChanged: false, msg: nil)
                    }
                }
            }
        }
    }
}

class JMenuChangePwdModelService: NSObject {
    weak var presenter: JMenuChangePwdPresenter?
    init(presenter: JMenuChangePwdPresenter) {
        super.init()
        self.presenter = presenter
    }
}
