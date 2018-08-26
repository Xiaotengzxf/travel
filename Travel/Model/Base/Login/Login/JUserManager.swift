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
    
    override init() {
        super.init()
        decodeUserAccount()
    }
    
    // MARK: Public
    
    func saveUserAccount(complete: Bool) {
        encodeUserAccount()
    }

    func logout() {
        removeUserAccountFile()
       
    }
    
    func deleteUserAccount() {
        removeUserAccountFile()
    }
    
    // MARK: Private
    
    private func decodeUserAccount() {
        user = NSKeyedUnarchiver.unarchiveObject(withFile: filePathForUserAccountData()) as? JUserModel
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
    
}
