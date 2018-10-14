//
//  JForgetPWDViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JForgetPWDViewController: SCBaseViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    private var modelService = JForgetPWDModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCodeButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7").cgColor
        sendCodeButton.layer.borderWidth = 0.5
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
    
    // MARK: - Public
    
    // MARK: - Private
    
    @IBAction func sendCode(_ sender: Any) {
        if let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), phone.count > 0 {
            if phone.validatePhone() {
                JHUD.show(at: self.view)
                modelService.getToken(mobilePhone: phone) {[weak self] (result, message) in
                    JHUD.hide(for: self!.view)
                    if message != nil {
                        Toast(text: message).show()
                    }
                }
            } else {
                Toast(text: "手机号码有误").show()
            }
        } else {
            Toast(text: "请输入手机号码").show()
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), phone.count > 0 {
            if phone.validatePhone() {
                if let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), pwd.count > 0 {
                    if let repwd = confirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), repwd.count > 0 && pwd == repwd {
                        if let code = codeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), code.count > 0 {
                            JHUD.show(at: self.view)
                            modelService.forgetPWD(phone: phone, password: pwd, code: code) {[weak self] (result, message) in
                                JHUD.hide(for: self!.view)
                                if result {
                                    self?.navigationController?.popViewController(animated: true)
                                }
                                if message != nil {
                                    Toast(text: message!).show()
                                }
                            }
                        } else {
                            Toast(text: "请先获取验证码").show()
                        }
                    } else {
                        Toast(text: "二次密码输入不一致").show()
                    }
                } else {
                    Toast(text: "请输入密码").show()
                }
            } else {
                Toast(text: "手机号码有误").show()
            }
        } else {
            Toast(text: "请输入手机号码").show()
        }
    }
}

extension JForgetPWDViewController: UITextFieldDelegate {
    
}
