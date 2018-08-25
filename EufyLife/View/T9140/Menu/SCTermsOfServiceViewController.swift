//
//  SCTermsOfServiceViewController.swift
//  Jouz
//
//  Created by SeanGao on 2018/1/10.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Localize_Swift

class SCTermsOfServiceViewController: SCBaseWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentLanguage = SCLanguageManager.sharedInstance.currentLanguage() as NSString
        if currentLanguage.contains("en") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=us"
        } else if currentLanguage.contains("zh") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=cn"
        } else if currentLanguage.contains("de") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=de"
        } else if currentLanguage.contains("it") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=it"
        } else if currentLanguage.contains("fr") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=fr"
        } else if currentLanguage.contains("es") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=es"
        } else if currentLanguage.contains("ru") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=ru"
        } else if currentLanguage.contains("ar") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=sa"
        } else if currentLanguage.contains("pt") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=pt"
        } else if currentLanguage.contains("ja") {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=jp"
        } else {
            self.strUrl = "https://www.anker.com/deals/Jouz_app_term?country=us"
        }
        loadUrl(url: self.strUrl!)
        sendScreenView()
    }
}

