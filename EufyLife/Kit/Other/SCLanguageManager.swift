//
//  SCLanguageManager.swift
//  Jouz
//
//  Created by SeanGao on 2018/1/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Localize_Swift

class SCLanguageManager: NSObject {
    
    static let sharedInstance = SCLanguageManager()
    
    /// - Returns: 当前系统设置的语言
    func currentSystemLanguage() -> String{
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        return preferredLang as String
    }
    
    /// - Returns: 用户当前设置生效的语言
    func currentCustomerLanguage() -> String {
        return UserDefaults.standard.object(forKey: udCustomrLanguageCode) as! String
    }
    
    /// - Returns: 当前设置生效的语言
    func currentLanguage() -> String {
        if self.isCustomerLanguageHasBeenSet() { // 如果用户App设置过 以用户设置为准
            return self.currentCustomerLanguage()
        } else {  //否则跟随系统设置
            return self.currentSystemLanguage()
        }
    }
    
    /// - Returns: 用户是否已自定义过 App 语言
    func isCustomerLanguageHasBeenSet() -> Bool {
        if (UserDefaults.standard.object(forKey: udCustomrLanguageCode) != nil) {
            return true
        } else {
            return false
        }
    }
    
    /// 将 App 设置用户自定义选中语言
    func setCustomerLanguage(_ languageCode: String) {
        UserDefaults.standard.set(languageCode, forKey: udCustomrLanguageCode)
        Localize.setCurrentLanguage(languageCode)
    }
    
    /// app 启动时配置语言
    func appLanuchLanguageConfig() {
        Localize.setCurrentLanguage(self.currentLanguage())
    }
    
}
