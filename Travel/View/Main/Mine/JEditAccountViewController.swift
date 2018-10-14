//
//  JEidtAccountViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JEditAccountViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    private var value: String?
    private var isPhone: Bool = false
    weak var delegate: JEditAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPhone {
            textField.keyboardType = .numberPad
        }
        textField.text = value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    public func intentData(value: String?, isPhone: Bool) {
        self.value = value
        self.isPhone = isPhone
    }
    
    // MARK: - Action

    @IBAction func save(_ sender: Any) {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 0 {
            if isPhone && !text.validatePhone() {
                Toast(text: "手机号码输入有误").show()
                return
            }
            delegate?.refreshData(value: text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension JEditAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 > 11 && range.length == 0 {
            return false
        }
        return true
    }
}

protocol JEditAccountViewControllerDelegate: NSObjectProtocol {
    func refreshData(value: String)
}
