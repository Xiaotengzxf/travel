//
//  JLoginViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/4/12.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRootViewController: JLoginBaseViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet var tipLabels: [UILabel]!
    
    private var presenter: JRootPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        setupSubviewPropertyValue()
        presenter = JRootPresenter()
        sendScreenView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginButton.addObserver(self, forKeyPath: "highlighted", options: [.new, .old], context: nil)
        signUpButton.addObserver(self, forKeyPath: "highlighted", options: [.new, .old], context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loginButton.removeObserver(self, forKeyPath: "highlighted")
        signUpButton.removeObserver(self, forKeyPath: "highlighted")
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
        if navigationItem.rightBarButtonItem == nil {
            if let viewController = segue.destination as? JLoginViewController {
                viewController.fromMenu = true
            } else if let viewController = segue.destination as? JSignUpViewController {
                viewController.fromMenu = true
            }
        }
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "highlighted" {
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Public
    
    
    // MARK: - Private
    
    private func setupSubviewPropertyValue() {
        let size = CGSize(width: screenWidth - 80, height: 50)
        let radius: CGFloat = 25
        loginView.setBlurBackground(size: size, cornerRadius: radius, addShadow: false)
        signUpView.setBlurBackground(size: size, cornerRadius: radius, addShadow: false)
        loginButton.setTitle("l_s_sign_up_sign_in".localized(), for: .normal)
        signUpButton.setTitle("l_s_sign_up_sign_up".localized(), for: .normal)
        loginButton.setTitleColor(c8, for: .normal)
        signUpButton.setTitleColor(c8, for: .normal)
        loginButton.titleLabel?.font = t3
        signUpButton.titleLabel?.font = t3
        for label in tipLabels {
            label.textColor = c8
            label.font = t1
        }
        tipLabels[0].text = "Welcome."
        tipLabels[1].text = "Your Health,"
        tipLabels[2].text = "Your Smart life."
    }
}
