//
//  JFeedbackViewController.swift
//  Jouz
//
//  Created by doubll on 2018/6/6.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JFeedbackViewController: JMenuBaseViewController {

    func resetHolderText() {
        textView.text = "cnn_help_feedback_tips".localized()
        textView.textColor = c4
        textView.font = t3
    }

    lazy var textView: UITextView! = {
        let t = UITextView(frame: .zero)
        t.delegate = self
        t.keyboardAppearance = .dark
        return t
    }()

    override func needTitleView() -> Bool {
        return false
    }

    var presenter: JFeedbackPresenterDelegate!
    private var bToastShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "cnn_help_feedback".localized()
        resetHolderText()
        presenter = JFeedbackPresenter(viewDelegate: self)
        sendScreenView()
    }


    override func makeUI() {
        super.makeUI()
        makeTextView()
        makeSubmit()
    }


    /// feedback input view
    func makeTextView() {
        let container = UIView()
        view.addSubview(container)
        container.backgroundColor = .white
        container.snp.makeConstraints { (m) in
            m.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                m.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                m.top.equalTo(topLayoutGuide.snp.bottom)
            }
            let ratio: CGFloat = 240/667
            m.height.equalToSuperview().multipliedBy(ratio)
        }

        container.addSubview(textView)

        textView.snp.makeConstraints { (make) in
            let edge = UIEdgeInsetsMake(20, 20, 20, 20)
            make.edges.equalToSuperview().inset(edge)
        }
    }

    /// submit button
    func makeSubmit() {
        let right = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(submitEvent))
        self.navigationItem.rightBarButtonItem = right
    }

    @objc func submitEvent() {
        endEdit()
        if (textView.text != "cnn_help_feedback_tips".localized()) && (textView.text.count > 0) {
            presenter?.submitFeedback(content: textView.text, completion: {[weak self] (result, msg) in
                if msg?.count ?? 0 > 0 {
                    if msg == "\(kErrorNetworkOffline)" {
                        ZToast(text: "common_check_network".localized()).show()
                    }else {
                        ZToast(text: msg!).show()
                    }
                }
                if result {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        }
    }



    func endEdit() {
        textView.resignFirstResponder()
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
    
    @objc private func modifyToastFlag() {
        bToastShown = false
    }

}

extension JFeedbackViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            endEdit()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "cnn_help_feedback_tips".localized() {
            textView.text = ""
            textView.textColor = c3
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            resetHolderText()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let textContent = textView.text {
            if textContent.count > 1000 {
                let startIndex = textContent.startIndex
                let index = textContent.index(startIndex, offsetBy: 1000)
                let content = textContent[startIndex..<index]
                textView.text = String(content)
                if bToastShown {
                    return
                }
                bToastShown = true
                ZToast(text: "cnn_help_feedback_length_tips".localized()).show()
                perform(#selector(modifyToastFlag), with: nil, afterDelay: 2.9)
            }
        }
    }
}

extension JFeedbackViewController: JFeedbackViewDelegate {
    
}
