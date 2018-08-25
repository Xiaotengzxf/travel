//
//  JLoginViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JLoginViewController: JLoginBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: JTextField!
    @IBOutlet weak var emailTipLabel: UILabel!
    @IBOutlet weak var pwdTextField: JTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPWDButton: UIButton!
    
    @IBOutlet weak var loginButtonBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldHeightLConstraint: NSLayoutConstraint!
    @IBOutlet weak var pwdTextFieldHeightLConstraint: NSLayoutConstraint!
    private var presenter: JLoginPresenterDelegate?
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0

    var fromMenu: Bool = false //从menu页跳转进入时设置为true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewPropertyValue()
        presenter = JLoginPresenter(viewDelegate: self)
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        pwdTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.textField.removeTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        pwdTextField.textField.removeTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        NotificationCenter.default.removeObserver(self)
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
        if let viewController = segue.destination as? JForgetPWDViewController {
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if email?.count ?? 0 > 0 &&
                email?.validateEmail() ?? false {
                viewController.carriedEmail = email
            }
        }
    }
    
    // MARK: - Private
    // 设置子视图属性值
    private func setupSubviewPropertyValue() {
        title = ""
        titleLabel.font = t1
        titleLabel.textColor = c2
        titleLabel.text = "l_s_sign_up_sign_in".localized()
        
        forgetPWDButton.setTitleColor(c1, for: .normal)
        forgetPWDButton.titleLabel?.font = t5
        forgetPWDButton.setTitle("l_s_sign_up_forgot_password".localized(), for: .normal)
        
        loginButton.setBackground(size: CGSize(width: screenWidth, height: 50), cornerRadius: 0, addShadow: false)
        loginButton.setTitleColor(c8, for: .normal)
        loginButton.titleLabel?.font = t3
        loginButton.setTitle("Log in", for: .normal)
        
        if let email = UserDefaults.standard.object(forKey: kEmail) as? String {
            emailTextField.textField.text = email
            pwdTextField.textField.becomeFirstResponder()
        } else {
            emailTextField.textField.becomeFirstResponder()
        }
        
        emailTextField.delegate = self
        pwdTextField.delegate = self
        emailTextField.setup(placeholder: "Email")
        pwdTextField.setup(bPWD: true, placeholder: "Password")
        pwdTextField.textField.keyboardType = .numbersAndPunctuation
        
        emailTipLabel.textColor = c9
        emailTipLabel.font = t4
        
        contentView.backgroundColor = c7
    }
    
    private func pushToBluetoothSettings() {
        let storyboard = UIStoryboard(name: "T9140", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "JBluetoothSettingViewController") as? JBluetoothSettingViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func textFieldValueChanged(_ sender: Any) {
        emailTextField.showRightView(bShow: false)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        loginButtonBottomLConstraint.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + 50, 0)
    }
    
    @objc private func UIKeyboardWillHide(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        keyboardHeight = 0
        loginButtonBottomLConstraint.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func checkForEmailAndPwdText(textField: JTextField? = nil) {
        if let email = emailTextField.text {
            if email.count > 30 {
                let index = email.index(email.startIndex, offsetBy: 30)
                emailTextField.text = String(email[..<index])
            }
        }
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if email?.count ?? 0 > 0 &&
            email?.validateEmail() ?? false {
            emailTextField.showRightView(bShow: false)
            if textField == emailTextField {
                return
            }
        } else {
            emailTextField.showRightView(bShow: true, message: "Please enter your email address.")
            return
        }
        
        let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let filterText = filterCharacter(text: pwd)
        if filterText.count > 20 {
            let index = filterText.index(filterText.startIndex, offsetBy: 20)
            pwdTextField.text = String(filterText[..<index])
        } else {
            pwdTextField.text = filterText
        }
        if filterText.count >= 8 {
            emailTipLabel.text = nil
        } else {
            emailTipLabel.text = "Password must be 8 - 20 digits, letters or characters."
        }
    }
    
    private func filterCharacter(text: String) -> String {
        do {
            let regularExpression = try NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: .caseInsensitive)
            return regularExpression.stringByReplacingMatches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count), withTemplate: "")
        } catch {
            
        }
        return ""
    }

    // MARK: - Action
    
    @IBAction func login(_ sender: Any) {
        checkForEmailAndPwdText()
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if email.validateEmail() && pwd.count >= 8 {
            showHUD()
            presenter?.login(email: email, password: pwd, callback: {[weak self] (isSuccess, message, complete) in
                self?.hideHUD()
                if isSuccess {
                    if complete {
                        let storyboard = UIStoryboard(name: "T9140", bundle: nil)
                        if let navigationController = storyboard.instantiateViewController(withIdentifier: "JNavigationController") as? UINavigationController {
                            UIApplication.shared.delegate?.window??.rootViewController = navigationController
                            self?.navigationController?.viewControllers = []
                        }
                    } else {
                        if let congratsViewController = self?.storyboard?.instantiateViewController(withIdentifier: "JCongratsViewController") as? JCongratsViewController {
                            self?.navigationController?.pushViewController(congratsViewController, animated: true)
                        }
                    }
                } else {
                    if message == "\(kErrorNetworkOffline)" {
                        ZToast(text: "common_check_network".localized()).show()
                    } else if message == nil {
                        ZToast(text: "cnn_update_firmware_error_try".localized()).show()
                    } else {
                        if message?.count ?? 0 > 0 {
                            self?.emailTipLabel.text = message
                        }
                    }
                }
            })
        } else {
            
        }
    }

}

extension JLoginViewController: JTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: JTextField) {
        if textField == emailTextField {
            textField.showRightView(bShow: false)
        }
    }
    
    func textFieldDidEndEditing(_ textField: JTextField) {
        checkForEmailAndPwdText(textField: textField)
    }
    
    func textField(_ textField: JTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let email = emailTextField.text {
            if email.count >= 30 {
                if range.length == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func textField(_ textField: JTextField, height: CGFloat) {
        if textField == emailTextField {
            emailTextFieldHeightLConstraint.constant = height
        } else {
            pwdTextFieldHeightLConstraint.constant = height
        }
    }
}

extension JLoginViewController: JLoginViewDelegate {
    
}
