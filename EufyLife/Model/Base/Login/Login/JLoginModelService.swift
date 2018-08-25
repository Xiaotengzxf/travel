//
//  JLoginModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginModelService: NSObject {
    
    weak var presenter: JLoginPresenterDelegate?
    
    init(presenter: JLoginPresenterDelegate) {
        super.init()
        self.presenter = presenter
    }
    
    // MARK: - Private
    
    private func saveUserMember(array: [Customer]?) {
        if let customers = array, customers.count > 0 {
            JUserManager.sharedInstance.members = customers
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
    
    private func saveDevices(array: [Device]?) {
        if let devices = array, devices.count > 0 {
            JUserManager.sharedInstance.deivces = devices
            var arr : [[String: Any]] = []
            for item in devices {
                var dic : [String: Any] = [:]
                dic["mac"] = item.bluetooth?.ble_mac
                dic["name"] = item.name
                dic["sn"] = item.sn
                dic["softwareVersion"] = item.software_version
                dic["userId"] = item.user_id
                arr.append(dic)
            }
            let deviceList = JDeviceData()
            if deviceList.insert(array: arr) {
                print("device insert db success")
            }
        }
    }
}

extension JLoginModelService: JLoginModelServiceDelegate {
    
    func login(email: String, password: String, callback: @escaping (Bool, String?, Bool) -> ()) {
        let request = JLoginRequestModel(email: email, password: password)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) {[weak self] (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data)
                    if model?.res_code == 1 {
                        UserDefaults.standard.set(email, forKey: kEmail)
                        JUserManager.sharedInstance.user = model?.responseToUser()
                        JUserManager.sharedInstance.user?.customer_count = model?.customers?.count ?? 0
                        let complete = model?.customers?.count ?? 0 > 0
                        JUserManager.sharedInstance.saveUserAccount(complete: complete)
                        self?.saveUserMember(array: model?.customers)
                        self?.saveDevices(array: model?.devices)
                        callback(true, nil, complete)
                    } else {
                        callback(false, model?.message, false)
                    }
                } else {
                    print("登录时，服务器有异常")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "\(kErrorNetworkOffline)", false)
                    } else {
                        callback(false, nil, false)
                    }
                }
            }
        }
    }
}
