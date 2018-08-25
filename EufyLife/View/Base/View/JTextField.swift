//
//  JTextField.swift
//  Jouz
//
//  Created by ANKER on 2018/5/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JTextField: UIView {
    
    var view: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipLabelBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var showButtonTopLConstraint: NSLayoutConstraint!
    @IBOutlet weak var showButtonRightLConstraint: NSLayoutConstraint!
    weak var delegate: JTextFieldDelegate?
    private var isPWD = false
    private var isShowError = false
    private var placeholder: String?
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupSubviewPropertyValue()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupSubviewPropertyValue()
    }
    
    private func loadViewFromNib() -> UIView  {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view]))
    }
    
    private func setupSubviewPropertyValue() {
        tipLabel.textColor = c8
        tipLabel.font = t5
        textField.textColor = c2
        textField.font = t3
        showButton.setTitleColor(c3, for: .normal)
        showButton.titleLabel?.font = t5
        showButton.setImage(UIImage(named: "signup_icon_blink"), for: .normal);
    }
    
    // MARK: - Public
    
    func showRightView(bShow: Bool, message: String? = nil) {
        isShowError = bShow
        if bShow {
            view.backgroundColor = c9
            textField.textColor = c8
            showButton.isHidden = false
            showButton.setImage(UIImage(named: "signup_icon_close"), for: .normal)
            showButtonTopLConstraint.constant = 15
            showButtonRightLConstraint.constant = 15
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7
            let attributeText = NSMutableAttributedString(string: message ?? "", attributes: [.font: t5, .foregroundColor: c8, .paragraphStyle : style])
            tipLabel.attributedText = attributeText
            tipLabelBottomLConstraint.constant = -10
            let height = attributeText.boundingRect(with: CGSize(width: screenWidth - 30, height: 1000), options: [.usesLineFragmentOrigin], context: nil).size.height + 4
            delegate?.textField(self, height: height + 60)
            if placeholder != nil {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [.font : t3, .foregroundColor: c8])
            }
        } else {
            view.backgroundColor = c8
            textField.textColor = c2
            if isPWD {
                showButton.isHidden = false
                showButton.setImage(UIImage(named: textField.isSecureTextEntry ? "signup_icon_closeeyes" : "signup_icon_blink"), for: .normal)
            } else {
                showButton.isHidden = true
            }
            tipLabel.attributedText = nil
            showButtonTopLConstraint.constant = 10
            showButtonRightLConstraint.constant = 20
            tipLabelBottomLConstraint.constant = 0
            delegate?.textField(self, height: 50)
            if placeholder != nil {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [.font : t3, .foregroundColor: c3])
            }
        }
    }
    
    func setup(bPWD: Bool = false, placeholder: String? = nil) {
        isPWD = bPWD
        self.placeholder = placeholder
        if placeholder?.count ?? 0 > 0 {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [.font : t3, .foregroundColor: c3])
        } else {
            textField.attributedPlaceholder = nil
        }
        showButton.isHidden = !bPWD
    }
    
    // MARK: - Action

    @IBAction func showOrHidePWD(_ sender: Any) {
        if isShowError {
            showRightView(bShow: false)
            textField.becomeFirstResponder()
        } else {
            textField.isSecureTextEntry = !textField.isSecureTextEntry
            showButton.setImage(UIImage(named: textField.isSecureTextEntry ? "signup_icon_closeeyes" : "signup_icon_blink"), for: .normal)
            let text = textField.text
            textField.text = " "
            textField.text = text
            if textField.isSecureTextEntry {
                textField.insertText(textField.text ?? "")
            }
        }
    }
}

extension JTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        if textField.isSecureTextEntry {
            textField.insertText(textField.text ?? "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}

protocol JTextFieldDelegate: NSObjectProtocol {
    func textFieldDidBeginEditing(_ textField: JTextField)
    func textFieldDidEndEditing(_ textField: JTextField)
    func textField(_ textField: JTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textField(_ textField: JTextField, height: CGFloat)
}
