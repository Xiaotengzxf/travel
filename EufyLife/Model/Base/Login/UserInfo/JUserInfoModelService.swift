//
//  JUserInfoModelService.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUserInfoModelService: NSObject {
    
    private func saveUserMember(array: [Customer]?) {
        if let customers = array, customers.count > 0 {
            JUserManager.sharedInstance.members += customers
            var arr : [[String: Any]] = []
            for item in customers {
                var dic : [String: Any] = [:]
                dic["id"] = item.id ?? ""
                dic["avatar"] = item.avatar ?? ""
                dic["birthday"] = Int32(item.birthday)
                dic["customer_no"] = Int32(item.customer_no)
                dic["defaultValue"] = item.defaultValue
                dic["height"] = Int32(item.height)
                dic["index"] = Int32(item.index)
                dic["name"] = item.name ?? ""
                dic["sex"] = item.sex ?? ""
                dic["target_weight"] = Int32(item.target_weight)
                arr.append(dic)
            }
            let member = JMemberData()
            if member.insert(array: arr) {
                print("member insert db success")
            }
        }
    }
}

extension JUserInfoModelService: JUserInfoDelegate {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?) -> ()) {
        let request = JAddCustomerRequestModel(name: name, sex: sex, age: age, height: height)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let data = value?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let model = try? JSONDecoder().decode(JAddCustomerResponseModel.self, from: data)
                if model?.res_code == 1 {
                    JUserManager.sharedInstance.user?.customer_count = 1
                    if let customer = model?.customer {
                        self?.saveUserMember(array: [customer])
                    }
                    NotificationCenter.default.post(name: kJSideMenuModelServiceNotification, object: kA)
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
