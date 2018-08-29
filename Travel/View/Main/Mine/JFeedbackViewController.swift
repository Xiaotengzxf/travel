//
//  JFeedbackViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/26.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JFeedbackViewController: SCBaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
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
    }
}
