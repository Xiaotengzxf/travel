//
//  JEditUserInfoModelService.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JEditUserInfoModelService: NSObject {
    
    private func saveUserMember(customer: Customer?) {
        if let item = customer {
            JUserManager.sharedInstance.members += [item]
            var arr : [[String: Any]] = []
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
            let member = JMemberData()
            if member.insert(array: arr) {
                print("member insert db success")
            }
        }
    }
    
    private func editUserMember(customer: Customer?) {
        if let item = customer {
            JUserManager.sharedInstance.editMember(customer: item)
            let member = JMemberData()
            member.update(array: [item])
        }
        
    }
    
    private func deleteMember(customerId: String) {
        JUserManager.sharedInstance.deleteMember(customerId: customerId)
        let member = JMemberData()
        if let array = member.select(condition: customerId) as? [MemberData] {
            member.delete(array: array)
        }
    }
    
}

extension JEditUserInfoModelService: JEditUserInfoDelegate {
    func addCustomer(name: String, sex: String, age: Int, height: Int, callback: @escaping (Bool, String?) -> ()) {
        let request = JAddCustomerRequestModel(name: name, sex: sex, age: age, height: height)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "PUT", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let data = value?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let model = try? JSONDecoder().decode(JAddCustomerResponseModel.self, from: data)
                if model?.res_code == 1 {
                    JUserManager.sharedInstance.user!.customer_count! += 1
                    self?.saveUserMember(customer: model?.customer)
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
    
    func deleteCustomer(customerId: String, callback: @escaping (Bool, String?) -> ()) {
        let request = JDeleteCustomerRequestModel(customerId: customerId)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "DELETE", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let data = value?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
                if model?.res_code == 1 {
                    JUserManager.sharedInstance.user!.customer_count! -= 1
                    self?.deleteMember(customerId: customerId)
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
    
    func editCustomer(customer: Customer, callback: @escaping (Bool, String?) -> ()) {
        let request = JEditCustomerRequestModel(customer: customer)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let data = value?.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let model = try? JSONDecoder().decode(JAddCustomerResponseModel.self, from: data)
                if model?.res_code == 1 {
                    self?.editUserMember(customer: model?.customer)
                    let obj = model?.customer?.index == 0 ? kB : kA
                    NotificationCenter.default.post(name: kJSideMenuModelServiceNotification, object: obj)
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
