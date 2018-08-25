//
//  JSignUpViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import TYAttributedLabel

class JSignUpViewController: JLoginBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: JTextField!
    @IBOutlet weak var pwdTextField: JTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var marketoButton: UIButton!
    @IBOutlet weak var emailTipLabel: UILabel!
    @IBOutlet weak var pwdTipLabel: TYAttributedLabel!
    @IBOutlet weak var signUpButtonBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var pwdTipLabelHeightLConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldHeightLConstraint: NSLayoutConstraint!
    @IBOutlet weak var pwdTextFieldHeightLConstraint: NSLayoutConstraint!
    
    var presenter: JSignUpPresenterDelegate?
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0
    
    var fromMenu: Bool = false //从menu页跳转进入时设置为true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        setupSubviewPropertyValue()
        setLinkLabelText()
        presenter = JSignUpPresenter(viewDelegate: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private
    
    private func setupSubviewPropertyValue() {
        titleLabel.font = t1
        titleLabel.textColor = c2
        titleLabel.text = "l_s_sign_up_sign_up".localized()
        
        emailTipLabel.text = "Enter a password containing 8-20 characters with at least 1 upper case and numeric character"
        emailTipLabel.textColor = c4
        emailTipLabel.font = t4
        
        marketoButton.setTitleColor(c4, for: .normal)
        marketoButton.titleLabel?.font = t5
        marketoButton.setImage(UIImage(named: "signup_icon_square"), for: .normal)
        marketoButton.setTitle("Receive news and product updates from Eufy", for: .normal)
        signUpButton.setTitleColor(c8, for: .normal)
        signUpButton.titleLabel?.font = t3
        signUpButton.setBackground(size: CGSize(width: screenWidth, height: 50), cornerRadius: 0, addShadow: false)
        signUpButton.setTitle("Register", for: .normal)
        
        emailTextField.delegate = self
        pwdTextField.delegate = self
        emailTextField.setup(placeholder: "Email")
        pwdTextField.setup(bPWD: true, placeholder: "Password")
        pwdTextField.textField.keyboardType = .numbersAndPunctuation
        emailTextField.textField.becomeFirstResponder()
        
        contentView.backgroundColor = c7
    }
    
    private func pushToBluetoothSettings() {
        let storyboard = UIStoryboard(name: "T9140", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "JBluetoothSettingViewController") as? JBluetoothSettingViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        signUpButtonBottomLConstraint?.constant = keyboardHeight
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
        signUpButtonBottomLConstraint?.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func setLinkLabelText() {
        pwdTipLabel.delegate = self
        pwdTipLabel.textAlignment = .center
        let text = NSString(string: "By signing up, you agree to the Privacy Policy, Data Policy and Terms of use.")
        let term = "Terms of use"
        let rangeTerm = text.range(of: term)
        let policy = "Privacy Policy"
        let rangePolicy = text.range(of: policy)
        let dataPolicy = "Data Policy"
        let rangeData = text.range(of: dataPolicy)
        let frontLocation = rangePolicy.location
        let frontLength = rangePolicy.length
        let midLocation = rangeData.location
        let midLength = rangeData.length
        let lastLocation = rangeTerm.location
        let lastLength = rangeTerm.length
        
        let prefix = NSMutableAttributedString(string: text.substring(with: NSMakeRange(0, frontLocation)))
        prefix.addAttributeTextColor(c3)
        prefix.addAttributeFont(t4)
        pwdTipLabel.appendTextAttributedString(prefix)
        
        pwdTipLabel.appendLink(withText: policy, linkFont: t4, linkColor: c1, linkData: "1")
        
        let middle = NSMutableAttributedString(string: text.substring(with: NSMakeRange(frontLocation + frontLength, midLocation - frontLocation - frontLength)))
        middle.addAttributeTextColor(c3)
        middle.addAttributeFont(t4)
        pwdTipLabel.appendTextAttributedString(middle)
        
        pwdTipLabel.appendLink(withText: dataPolicy, linkFont: t4, linkColor: c1, linkData: "2")
        
        let supfix = NSMutableAttributedString(string: text.substring(with: NSMakeRange(midLocation + midLength, lastLocation - midLocation - midLength)))
        supfix.addAttributeTextColor(c3)
        supfix.addAttributeFont(t4)
        pwdTipLabel.appendTextAttributedString(supfix)
        
        pwdTipLabel.appendLink(withText: term, linkFont: t4, linkColor: c1, linkData: "3")
        
        let last = NSMutableAttributedString(string: text.substring(with: NSMakeRange(lastLocation + lastLength, text.length - lastLocation - lastLength)))
        last.addAttributeTextColor(c3)
        last.addAttributeFont(t4)
        pwdTipLabel.appendTextAttributedString(last)
        
        pwdTipLabelHeightLConstraint.constant = CGFloat(pwdTipLabel.getHeightWithWidth(screenWidth - 40))
    }

    // MARK: - Action
    @IBAction func markeToNews(_ sender: Any) {
        marketoButton.isSelected = !marketoButton.isSelected
    }
    
    @IBAction func signUp(_ sender: Any) {
        checkForEmailAndPwdText()
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if email.validateEmail() && pwd.count >= 8 {
            signUpButton.isEnabled = false
            showHUD()
            presenter?.signUp(email: email, password: pwd, name: "", isSubscribe: !marketoButton.isSelected, callback: {[weak self] (value, message) in
                self?.hideHUD()
                if value {
                    if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "JCongratsViewController") as? JCongratsViewController {
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                } else {
                    if message == "\(kErrorNetworkOffline)" {
                        Toast(text: "common_check_network".localized()).show()
                        self?.signUpButton.isEnabled = true
                    } else if message == nil {
                        Toast(text: "cnn_update_firmware_error_try".localized()).show()
                        self?.signUpButton.isEnabled = true
                    } else {
                        if message?.count ?? 0 > 0 {
                            self?.emailTextField.showRightView(bShow: true, message: message ?? "")
                        }
                    }
                }
            })
        }
    }
    
    // MARK: -
    
    @objc private func textFieldValueChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            if textField == emailTextField {
                emailTextField.showRightView(bShow: false)
            }else {
                pwdTextField.showRightView(bShow: false)
            }
        }
    }
    
    private func checkForEmailAndPwdText(textField: JTextField? = nil) {
        if let email = emailTextField.text {
            if email.count > 30 {
                let index = email.index(email.startIndex, offsetBy: 30)
                emailTextField.text = String(email[..<index])
            }
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).validateEmail() ?? false {
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
            pwdTextField.showRightView(bShow: false)
            emailTipLabel.textColor = c4
        } else {
            pwdTextField.showRightView(bShow: true)
            emailTipLabel.textColor = c9
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
}

extension JSignUpViewController: JTextFieldDelegate {
    
    func textField(_ textField: JTextField, height: CGFloat) {
        if textField == emailTextField {
            emailTextFieldHeightLConstraint.constant = height
        } else {
            pwdTextFieldHeightLConstraint.constant = height
        }
    }
    
    func textFieldDidBeginEditing(_ textField: JTextField) {
        textField.showRightView(bShow: false)
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
}

extension JSignUpViewController: JSignUpViewDelegate {
    
    
}

extension JSignUpViewController: TYAttributedLabelDelegate {
    
}
