//
//  JLoginViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JLoginViewController: SCBaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPWDButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    let service = JLoginModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        pwdTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: - Action
    
    @IBAction func login(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if phone.count == 11 && pwd.count > 0 && pwd.count <= 20 {
            JHUD.show(at: self.view)
            service.login(mobilePhone: phone, password: pwd.md5()) {[weak self] (result, message) in
                JHUD.hide(for: self!.view)
                if result {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storyboard.instantiateViewController(withIdentifier: "JTabBarController") as? JTabBarController {
                        self?.view.window?.rootViewController = vc
                        self?.navigationController?.viewControllers = []
                    }
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }

}

extension JLoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            phoneTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        }
        if textField == pwdTextField {
            pwdTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            if let text = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count == 11 {
                phoneTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
            } else {
                phoneTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
        if textField == pwdTextField {
            if let text = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 0 && text.count <= 20 {
                pwdTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
            } else {
                pwdTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 11 {
                if range.length == 0 {
                    return false
                }
            }
        }
        
        if textField == pwdTextField {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 20 {
                if range.length == 0 {
                    return false
                }
            }
        }
        
        return true
    }
}
