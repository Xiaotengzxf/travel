//
//  JRootNavigationController.swift
//  Jouz
//
//  Created by ANKER on 2018/6/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = c7
        let value = UserDefaults.standard.bool(forKey: kWelcomeKey)
        if value {
            if JUserManager.sharedInstance.getLoginStatus() == .loginUser {
                JUserManager.sharedInstance.refreshUserInfo()
                let storyboard = UIStoryboard(name: "T9140", bundle: nil)
                if let navigationController = storyboard.instantiateViewController(withIdentifier: "JNavigationController") as? UINavigationController {
                    UIApplication.shared.delegate?.window??.rootViewController = navigationController
                    self.viewControllers = []
                }
            } else if JUserManager.sharedInstance.getLoginStatus() == .login {
                if let rootController = self.storyboard?.instantiateViewController(withIdentifier: "JCongratsViewController") as? JCongratsViewController {
                    self.setViewControllers([rootController], animated: false)
                }
            }  else {
                if let rootController = self.storyboard?.instantiateViewController(withIdentifier: "JRootViewController") as? JRootViewController {
                    UserDefaults.standard.set(true, forKey: kWelcomeKey)
                    self.setViewControllers([rootController], animated: false)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
