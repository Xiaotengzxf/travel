//
//  JMenuPresenter.swift
//  Jouz
//
//  Created by doubll on 2018/4/24.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JMenuPresenter: NSObject {
    weak var viewDelegate: JMenuViewDelegate?
    var modelService: JMenuModelService?
    init(viewDelegate: JMenuViewDelegate?) {
        super.init()
        self.viewDelegate = viewDelegate
        self.modelService = JMenuModelService(presenter: self)
    }
}

extension JMenuPresenter: JMenuPresenterDelegate {

    /// presenter -> viewdelegate
    func callbackDidLogout() {
        self.viewDelegate?.callbackDidLogout()
    }

    func callbackDidSelect(_ option: String, _ idx: Int) {

        
    }
    
    func requestForShoppingActivity(callback: @escaping (String?, String?) -> ()) {
        modelService?.requestForShoppingActivity(callback: callback)
    }
}

extension JMenuPresenter {

    /// presenter -> service
    func login() {
        let sb = UIStoryboard.init(name: "Login", bundle: .main)
        let loginvc = sb.instantiateViewController(withIdentifier: "JRootViewController") as! JRootViewController
        (self.viewDelegate as! UIViewController).navigationController?.pushViewController(loginvc, animated: true)
    }

    func getLoginStatus() -> Bool {
        return modelService?.getLoginStatus() ?? false
    }

    func currentUserName() -> String? {
        return modelService?.currentUserName()
    }

    func didSelect(_ option: String, _ idx: Int) {
        modelService?.didSelect(option, idx)
    }

    func editProfile(){
    }

    func viewPolicy(idx: Int) {
        var country = ""
        let currentLanguage = SCLanguageManager.sharedInstance.currentLanguage() as NSString
        if currentLanguage.contains("ja") {
            country = "jp"
        } else {
            country = "us"
        }
        let policyVC = JTermsViewController()
        policyVC.url = idx == 1 ? "https://www.jouz.com/jouz_app_terms?country=\(country)" : "https://www.jouz.com/jouz_app_policy?country=\(country)"
        (self.viewDelegate as! UIViewController).navigationController?.pushViewController(policyVC, animated: true)

    }

}

