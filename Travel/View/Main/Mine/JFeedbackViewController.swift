//
//  JFeedbackViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/26.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JFeedbackViewController: SCBaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let service = JFeedbackModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        textView.layer.cornerRadius = 3.5
        textView.layer.borderWidth = 0.5
        textView.text = "输入您的反馈意见"
        textView.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "999999")
        textView.font = UIFont.systemFont(ofSize: 16)
        
        textField.font = UIFont.systemFont(ofSize: 16)
        
        submitButton.layer.borderWidth = 0.5
        submitButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7").cgColor
        submitButton.layer.cornerRadius = 4
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

    @IBAction func submitSuggestion(_ sender: Any) {
        let content = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if content.count == 0 {
            Toast(text: "请输入内容").show()
            return
        }
        if let mobilePhone = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), mobilePhone.count == 11 {
            JHUD.show(at: self.view)
            service.feedback(content: content, mobilePhone: mobilePhone) {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result {
                    Toast(text: "提交成功").show()
                    self?.navigationController?.popViewController(animated: true)
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        } else {
            Toast(text: "手机号码为空或有误").show()
        }
    }
}

extension JFeedbackViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "输入您的反馈意见" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            textView.text = "输入您的反馈意见"
        }
    }
}
