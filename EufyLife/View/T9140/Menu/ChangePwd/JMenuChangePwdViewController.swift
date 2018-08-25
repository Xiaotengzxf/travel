//
//  JMenuChangePwdViewController.swift
//  Jouz
//
//  Created by doubll on 2018/5/30.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import SnapKit

extension JMenuChangePwdViewController: JMenuChangePwdViewDelegate {
    
    func callback(passwordChanged success: Bool, msg: String?) {
        hideHUD()
        var tips = msg
        if success {
            tips = "cnn_change_pwd_success_tips".localized()
            ZToast(text: tips).show()
            self.navigationController?.popViewController(animated: true)
        } else {
            if msg == "\(kErrorNetworkOffline)" {
                ZToast(text: "common_check_network".localized()).show()
            } else if msg == nil {
                ZToast(text: "cnn_update_firmware_error_try".localized()).show()
            } else {
                showErrorView(message: msg ?? "")
            }
        }
    }
}

class JMenuChangePwdViewController: JMenuBaseViewController {

    var presenter: JMenuChangePwdPresenter?
    private var errorView: JErrorView?
    private var errorViewBottomLConstraint: NSLayoutConstraint?
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleKey = "cnn_change_pwd".localized()
        self.presenter = JMenuChangePwdPresenter(viewDelegate: self)
        // Do any additional setup after loading the view.
        confirmView.confirmClosure = {[weak self] in
            let oldPassword = self?.oldPwd.content
            let newPassword = self?.newPwd.content
            if oldPassword == newPassword {
                self?.showErrorView(message: "cnn_change_pwd_diff_tips".localized())
                return
            }
            self?.showHUD()
            self?.oldPwd.textField.resignFirstResponder()
            self?.newPwd.textField.resignFirstResponder()
            self?.confirmView.confirmButton.isEnabled = false
            self?.presenter?.changePassword(oldPassword: oldPassword!, newPassword: newPassword!)
        }
        oldPwd.textField.keyboardType = .numbersAndPunctuation
        newPwd.textField.keyboardType = .numbersAndPunctuation
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEventShow(ntf:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEventHide(ntf:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        sendScreenView()
    }

    @objc func keyboardEventShow(ntf: Notification) {
        let userinfo = ntf.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        errorViewBottomLConstraint?.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardEventHide(ntf: Notification) {
        let userinfo = ntf.userInfo! as NSDictionary
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        keyboardHeight = 0
        errorViewBottomLConstraint?.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    private func showErrorView(message: String) {
        if errorView == nil {
            errorView = Bundle.main.loadNibNamed("JErrorView", owner: nil, options: nil)?.first as? JErrorView
            errorView?.delegate = self
            errorView?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(errorView!)
        }
        let errorSource = "l_s_sign_up_error_email".localized()
        let errorArray = errorSource.components(separatedBy: "^^")
        let attrString = NSMutableAttributedString(string: "\(errorArray[0]) ", attributes: [.font: t5, .foregroundColor: c8])
        attrString.append(NSAttributedString(string: message, attributes: [.font: t5, .foregroundColor: c3]))
        errorView?.descLabel.attributedText = attrString
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": errorView!]))
        errorViewBottomLConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: errorView!, attribute: .bottom, multiplier: 1, constant: keyboardHeight)
        self.view.addConstraint(errorViewBottomLConstraint!)
    }

    var bgView: UIView!

    var oldPwd: JChangePwdOptionView!
    var newPwd: JChangePwdOptionView!
    lazy var confirmView: JChangePwdConfirmView! =
        {JChangePwdConfirmView()}()

    var topConstraint: Constraint?

    override func makeUI() {
        super.makeUI()
        if let titleView = titleView {
            bgView = UIView()
            view.addSubview(bgView)
            bgView.snp.makeConstraints { (m) in
                m.left.right.bottom.equalToSuperview()
                m.top.equalTo(titleView.snp.bottom)
            }

            oldPwd = JChangePwdOptionView(title: "cnn_change_pwd_current_pwd".localized())
            newPwd = JChangePwdOptionView(title: "cnn_change_pwd_new_pwd".localized())

            bgView.addSubview(oldPwd)
            bgView.addSubview(newPwd)
            bgView.addSubview(confirmView)

            oldPwd.snp.makeConstraints({ (m) in
                m.left.equalToSuperview().offset(kPaddingLeft)
                m.height.equalTo(90)
                m.top.equalToSuperview().offset(14)
                m.right.equalToSuperview().offset(-kPaddingRight)
            })

            newPwd.snp.makeConstraints({ (m) in
                m.top.equalTo(oldPwd.snp.bottom)
                m.left.right.height.equalTo(oldPwd)
            })


            confirmView.snp.makeConstraints({ (m) in
                m.top.equalTo(newPwd.snp.bottom)
                m.left.right.equalTo(newPwd)
                m.height.equalTo(85)
            })

            newPwd.addObserver(self, forKeyPath: "isValidInput", options: .new, context: &JMenuChangePwdViewController.kNewPwdCtx)
            oldPwd.addObserver(self, forKeyPath: "isValidInput", options: .new, context: &JMenuChangePwdViewController.kOldPwdCtx)
        }

    }

    deinit {
        newPwd.removeObserver(self, forKeyPath: "isValidInput", context: &JMenuChangePwdViewController.kNewPwdCtx)
        oldPwd.removeObserver(self, forKeyPath: "isValidInput", context: &JMenuChangePwdViewController.kOldPwdCtx)
    }


    private static var kNewPwdCtx = "kNewPwdCtx"
    private static var kOldPwdCtx = "kOldPwdCtx"

    var validOld: Bool = false
    var validNew: Bool = false


    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let ctx = context {
            closeErrorView()
            let newValue = change![NSKeyValueChangeKey.newKey] as! Bool
            if ctx == &JMenuChangePwdViewController.kNewPwdCtx {
                validNew = newValue
            }
            if ctx == &JMenuChangePwdViewController.kOldPwdCtx {
                validOld = newValue
            }

            let canProceed = (validNew && validOld) //&& (oldPwd.content != newPwd.content)

            if (canProceed) {
                
            } else if (oldPwd.content == newPwd.content) {
                /// 临时文案
                //alert.content = "cnn_change_pwd_diff_tips".localized()
            } else if (!oldPwd.isValidInput || !newPwd.isValidInput) {
                /// 临时文案
                //alert.content = "cnn_change_pwd_length_tips".localized()
            }
            self.confirmView.changeConfirm(status: canProceed)
        }
    }
}

//MARK: - 确认跳转框
class JChangePwdConfirmView: UIView {

    lazy var infoLabel: UILabel! = {
        let label = UILabel()
        label.text = "cnn_change_pwd_length_tips".localized()
        label.textColor = c3
        label.font = t5
        label.numberOfLines = 0
        return label
    }()

    var confirmClosure: (()->Void)?

    lazy var confirmButton: UIButton! = {
        let b = UIButton(type: UIButtonType.custom)
        b.setImage(UIImage(named: "common_icon_button_next"), for: .normal)
        b.addTarget(self, action: #selector(confirmEvent), for: .touchUpInside)
        return b
    }()

    @objc func confirmEvent() {
        confirmClosure?()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func changeConfirm(status: Bool) {
        self.confirmButton.isEnabled = status
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(infoLabel)
        addSubview(confirmButton)
        makeConstraints()
    }

    func makeConstraints() {
        confirmButton.snp.makeConstraints { (m) in
            m.right.equalToSuperview()
            m.centerY.equalToSuperview()
            let ratio: CGFloat = 44/90
            m.height.equalToSuperview().multipliedBy(ratio)
            m.width.equalTo(confirmButton.snp.height)
        }

        infoLabel.snp.remakeConstraints({ (m) in
            m.right.equalTo(confirmButton.snp.left).offset(-15)
            m.centerY.equalTo(confirmButton.snp.centerY)
            m.left.equalToSuperview()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension JChangePwdOptionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - 密码输入框
class JChangePwdOptionView: UIView {
    fileprivate class JTitleLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.textColor = c3
            self.font = t5
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    var content: String {
        get {
            return textField.text ?? ""
        }
    }

    fileprivate var titleLabel: JTitleLabel!
    var textField: UITextField!
    private var lowerLine: CellLineView!
    private var imageView: UIImageView!
    private var showButton: UIButton!
    @objc dynamic var isValidInput: Bool = false

    init(title: String, holder: String? = nil) {
        super.init(frame: .zero)
        lowerLine = CellLineView(position: .lower)
        titleLabel = JTitleLabel()
        textField = UITextField()
        addSubview(titleLabel)
        addSubview(textField)
        add(line: lowerLine)
        imageView = UIImageView()
        imageView.image = UIImage(named: "common_icon_selected")
        addSubview(imageView)
        titleLabel.text = title
        textField.placeholder = holder
        textField.keyboardAppearance = .dark
        textField.delegate = self
        textField.isSecureTextEntry = true
        /// show button
        showButton = UIButton(type: .custom)
        showButton.setTitle("cnn_change_pwd_show".localized(), for: .normal)
        showButton.setTitleColor(c3, for: .normal)
        showButton.titleLabel?.font = t5
        addSubview(showButton)
        showButton.addTarget(self, action: #selector(showPwdEvent), for: .touchUpInside)
        imageView.isHidden = true

        makeConstraints()

        NotificationCenter.default.addObserver(self, selector: #selector(textfieldChanged(nofitication:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

    }

    @objc func textfieldChanged(nofitication: Notification) {
        let pwd = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let filterText = filterCharacter(text: pwd)
        if filterText.count > 20 {
            let index = filterText.index(filterText.startIndex, offsetBy: 20)
            textField.text = String(filterText[..<index])
        } else {
            textField.text = filterText
        }
        if filterText.count >= 8 {
            imageView.isHidden = false
            isValidInput = true
        } else {
            imageView.isHidden = true
            isValidInput = false
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


    @objc func showPwdEvent() {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        if self.textField.isSecureTextEntry {
            showButton.setTitle("cnn_change_pwd_show".localized(), for: .normal)
        } else {
            showButton.setTitle("cnn_change_pwd_hide".localized(), for: .normal)
        }
        let text = textField.text
        textField.text = " "
        textField.text = text
        if textField.isSecureTextEntry {
            textField.insertText(textField.text ?? "")
        }
    }

    func makeConstraints() {
        /// input field for password
        textField.snp.makeConstraints { (m) in
            m.left.equalTo(lowerLine.snp.left)
            m.bottom.equalToSuperview().offset(-10)
            m.height.equalTo(22)
            m.right.equalTo(imageView.snp.left).offset(-15).priority(.high)
        }


        /// title for content input
        titleLabel.snp.makeConstraints { (m) in
            m.left.equalTo(textField.snp.left)
            m.height.equalTo(14)
            m.bottom.equalTo(textField.snp.top).offset(-16)
        }


        /// valid input imagev
        imageView.snp.makeConstraints { (m) in
            m.right.equalToSuperview()
            m.centerY.equalTo(textField.snp.centerY)
            let ratio: CGFloat = 24/90
            m.height.equalToSuperview().multipliedBy(ratio)
            m.width.equalTo(imageView.snp.height)
        }

        showButton.snp.makeConstraints { (m) in
            m.right.equalToSuperview()
            m.centerY.equalTo(titleLabel.snp.centerY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JMenuChangePwdViewController: JErrorViewDelegate {
    
    func closeErrorView() {
        confirmView.changeConfirm(status: oldPwd.isValidInput && newPwd.isValidInput)
        errorView?.removeFromSuperview()
        errorView = nil
        errorViewBottomLConstraint = nil
    }
    
}
