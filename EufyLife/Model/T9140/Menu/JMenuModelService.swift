//
//  JMenuModelService.swift
//  Jouz
//
//  Created by doubll on 2018/4/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMenuModelService: NSObject {
    weak var presenter: JMenuPresenterDelegate?
    init(presenter: JMenuPresenterDelegate?) {
        super.init()
        self.presenter = presenter
    }
}

extension JMenuModelService: JMenuModelServiceDelegate {
    func didSelect(_ option: String, _ idx: Int) {
        presenter?.callbackDidSelect(option, idx)
    }

    func getLoginStatus() -> Bool {
        return true
    }

    func currentUserName() -> String? {
        return nil
    }

    func requestPolicyInfo(completion: ((String?, String?, String?) -> Void)?) {
        let model = JUserPolicyRequestModel()
        ZNetwork().request(strUrl: model.url(), strMethod: "GET", parameters: nil, encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: model.toHeader()) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JUserPolicyResponseModel.self, from: data!)
                if model?.res_code == 1 {
                    completion?(model?.privacy_url,model?.terms_url,nil)
                    return
                }
            }
            completion?(nil,nil,nil)
        }
    }
    
    func requestForShoppingActivity(callback: @escaping (String?, String?) -> ()) {
       
        
    }
}
