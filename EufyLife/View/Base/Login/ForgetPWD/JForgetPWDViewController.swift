//
//  JForgetPWDViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/13.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JForgetPWDViewController: JLoginBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: JTextField!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var sendButtonBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldHeightLConstraint: NSLayoutConstraint!
    private var presenter: JForgetPWDPresenterDelegate?
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0
    public var carriedEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewPropertyValue()
        presenter = JForgetPWDPresenter(viewDelegate: self)
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.textField.removeTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
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
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setupSubviewPropertyValue() {
        titleLabel.font = t1
        titleLabel.textColor = c2
        titleLabel.text = "l_s_sign_up_forgot_password".localized()
        
        descLabel.font = t4
        descLabel.textColor = c3
        descLabel.text = "l_s_forgot_pwd_email_input".localized()
        
        sendButton.setBackground(size: CGSize(width: screenWidth, height: 50), cornerRadius: 0, addShadow: false)
        sendButton.setTitleColor(c8, for: .normal)
        sendButton.titleLabel?.font = t3
        sendButton.setTitle("Send verification email", for: .normal)
        
        if carriedEmail != nil {
            emailTextField.textField.text = carriedEmail
            checkForEmailText()
        } else {
            if let email = UserDefaults.standard.object(forKey: kEmail) as? String {
                emailTextField.textField.text = email
                checkForEmailText()
            }
        }
        
        emailTextField.delegate = self
        emailTextField.setup(placeholder: "Email")
        emailTextField.textField.becomeFirstResponder()
        
        contentView.backgroundColor = c7
    }
    
    @objc private func showAlertForSendEmail() {
        let text = "l_s_forgot_pwd_email_sent".localized()
        let title = "p_email_has_been_sent".localized()
        let start = title.startIndex
        let end = title.endIndex
        let alert = UIAlertController(title: String(title[start..<end]), message: text.replacingOccurrences(of: title, with: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "common_ok".localized(), style: .cancel, handler: {[weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true) {
            
        }
    }
    
    private func sendEmail() {
        showHUD()
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        presenter?.forgetPWD(email: email, callback: {[weak self] (result, message) in
            self?.hideHUD()
            if result {
                self?.showAlertForSendEmail()
            } else {
                if message == "\(kErrorNetworkOffline)" {
                    ZToast(text: "common_check_network".localized()).show()
                } else if message == nil {
                    ZToast(text: "cnn_update_firmware_error_try".localized()).show()
                } else {
                    if message?.count ?? 0 > 0 {
                        self?.emailTextField.showRightView(bShow: true, message: message ?? "")
                    }
                }
            }
        })
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        sendButtonBottomLConstraint.constant = keyboardHeight
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
        sendButtonBottomLConstraint.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: - Action
    
    @IBAction func sendEmail(_ sender: Any) {
        sendEmail()
    }
    
    // MARK: -
    
    @objc private func textFieldValueChanged(_ sender: Any) {
        
    }
    
    private func checkForEmailText() {
        if let email = emailTextField.text {
            if email.count > 30 {
                let index = email.index(email.startIndex, offsetBy: 30)
                emailTextField.text = String(email[..<index])
            }
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 &&
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).validateEmail() ?? false {
            emailTextField.showRightView(bShow: false)
        } else {
            emailTextField.showRightView(bShow: true, message: "Please enter your email address.")
        }
    }
}

extension JForgetPWDViewController: JTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: JTextField) {
        textField.showRightView(bShow: false)
    }
    
    func textFieldDidEndEditing(_ textField: JTextField) {
        checkForEmailText()
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
        emailTextFieldHeightLConstraint.constant = height
    }
}

extension JForgetPWDViewController: JForgetPWDViewDelegate {
    
}
