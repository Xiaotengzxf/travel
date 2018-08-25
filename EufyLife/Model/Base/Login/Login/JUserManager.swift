//
//  JLoginManager.swift
//  Jouz
//
//  Created by ANKER on 2018/5/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUserManager: NSObject {
    
    static let sharedInstance = JUserManager()
    var user: JUserModel?
    private var loginStatus: LoginStatus = .logOff
    var userLogOut = false
    var members: [Customer] = []
    var deivces: [Device] = []
    
    override init() {
        super.init()
        decodeUserAccount()
    }
    
    // MARK: Public
    
    func setLoginStatus(status: LoginStatus) {
        loginStatus = status
    }
    
    func getLoginStatus() -> LoginStatus {
        return loginStatus
    }
    
    func saveUserAccount(complete: Bool) {
        loginStatus = complete ? .loginUser : .login
        encodeUserAccount()
    }

    func logout() {
        userLogOut = true
        loginStatus = .logOff
        removeUserAccountFile()
        let memberData = JMemberData()
        if let members = memberData.select(condition: nil) as? [MemberData] {
            memberData.delete(array: members)
        }
        let deviceData = JDeviceData()
        if let devices = deviceData.select(condition: nil) as? [DeviceData] {
            deviceData.delete(array: devices)
        }
    }
    
    func deleteUserAccount() {
        loginStatus = .logOff
        removeUserAccountFile()
        let memberData = JMemberData()
        if let members = memberData.select(condition: nil) as? [MemberData] {
            memberData.delete(array: members)
        }
        let deviceData = JDeviceData()
        if let devices = deviceData.select(condition: nil) as? [DeviceData] {
            deviceData.delete(array: devices)
        }
    }
    
    func addMember(customer: Customer?) {
        if let model = customer {
            members.append(model)
        }
    }
    
    func deleteMember(customerId: String) {
        for (index, item) in members.enumerated() {
            if item.id == customerId {
                members.remove(at: index)
                return
            }
        }
    }
    
    func editMember(customer: Customer) {
        for (index, item) in members.enumerated() {
            if item.id == customer.id {
                members.replaceSubrange(index..<index+1, with: [customer])
                return
            }
        }
    }
    
    // MARK: Private
    
    private func decodeUserAccount() {
        user = NSKeyedUnarchiver.unarchiveObject(withFile: filePathForUserAccountData()) as? JUserModel
        if user != nil {
            if (user?.customer_count ?? 0) > 0 {
                readCustomer()
                readDevices()
            }
            isNeedRefreshToken()
        }
    }
    
    private func encodeUserAccount() {
        if user != nil {
            user!.expires_in! += Int(Date().timeIntervalSince1970)
            NSKeyedArchiver.archiveRootObject(user!, toFile: filePathForUserAccountData())
        }
    }
    
    private func removeUserAccountFile() {
        let filePath = filePathForUserAccountData()
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func filePathForUserAccountData() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return "\(path!)/userAccount.data"
    }
    
    private func isNeedRefreshToken() {
        if let expiresIn = user?.expires_in {
            let expireSecond = expiresIn - Int(Date().timeIntervalSince1970)
            if expireSecond < 60 * 60 * 1 {
                deleteUserAccount()
            }else if expireSecond < 60 * 60 * 24 * 2 {
                refreshToken()
                if user?.customer_count ?? 0 > 0 {
                    loginStatus = .loginUser
                } else {
                    loginStatus = .login
                }
            } else {
                if user?.customer_count ?? 0 > 0 {
                    loginStatus = .loginUser
                } else {
                    loginStatus = .login
                }
            }
        }
    }
    
    private func refreshToken() {
        let request = JRefreshTokenRequestModel(refreshToken: user?.refresh_token ?? "")
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JLoginResponseModel.self, from: data)
                    if model?.res_code == 1 {
                        JUserManager.sharedInstance.user = model?.responseToUser()
                        JUserManager.sharedInstance.saveUserAccount(complete: true)
                    }
                }
            }
        }
    }
    
    func refreshUserInfo() {
        let request = JGetUserInfoRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {[weak self] (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JUserUpdateResponseModel.self, from: data!)
                if model?.res_code == 1 {
                    let userModel = JUserManager.sharedInstance.user
                    if model != nil && userModel != nil {
                        let newUser = self!.merge(oldModel: model?.user_info, into: userModel)
                        JUserManager.sharedInstance.user = newUser
                        JUserManager.sharedInstance.saveUserAccount(complete: true)
                    }
                }
            }
        }
    }
    
    private func readCustomer() {
        print("开始读取 Customer data")
        let member = JMemberData()
        if let ms = member.select(condition: nil) as? [MemberData] {
            for item in ms {
                let custmor = Customer()
                custmor.avatar = item.avatar
                custmor.birthday = Int(item.birthday)
                custmor.customer_no = Int(item.customer_no)
                custmor.defaultValue = item.defaultValue
                custmor.height = Int(item.height)
                custmor.id = item.id
                custmor.index = Int(item.index)
                custmor.name = item.name
                custmor.sex = item.sex
                custmor.target_weight = Int(item.target_weight)
                members.append(custmor)
            }
        }
        members.sort{$0.index < $1.index}
    }
    
    private func readDevices() {
        print("开始读取 Device data")
        let deviceList = JDeviceData()
        if let list = deviceList.select(condition: user?.user_id ?? "") as? [DeviceData] {
            for item in list {
                let bluetooth = BlueTooth()
                bluetooth.ble_mac = item.mac
                let device = Device()
                device.bluetooth = bluetooth
                device.sn = item.sn
                device.name = item.name
                device.software_version = item.softwareVersion
                deivces.append(device)
            }
        }
    }
}

enum LoginStatus: Int {
    case logOff
    case login
    case loginUser
}
