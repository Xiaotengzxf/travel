//
//  JAddCommonContactViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JAddCommonContactViewController: UIViewController {
    
    var actionPeopleView: JApplyActionPeopleView!
    var type: String?
    private let service = JAddCommonContactModelService()

    override func viewDidLoad() {
        super.viewDidLoad()

        actionPeopleView = Bundle.main.loadNibNamed("JApplyActionPeopleView", owner: nil, options: nil)?.first as? JApplyActionPeopleView
        actionPeopleView.translatesAutoresizingMaskIntoConstraints = false
        actionPeopleView.delegate = self
        view.addSubview(actionPeopleView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[view]-(10)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": actionPeopleView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[view(183)]", options: .directionLeadingToTrailing, metrics: nil, views: ["view": actionPeopleView]))
        actionPeopleView.layer.cornerRadius = 7
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit(_:)))
    }
    

    @objc private func submit(_ sender: Any) {
        guard let realName = actionPeopleView.nameTextField.text, realName.count > 0 else {
            Toast(text: "请输入姓名").show()
            return
        }
        if type == nil {
            Toast(text: "请选择联系人类型").show()
            return
        }
        guard let cardNum = actionPeopleView.identifyCardTextField.text, cardNum.count > 0 else {
            Toast(text: "请输入身份证号").show()
            return
        }
        guard let phone = actionPeopleView.phoneTextField.text, phone.count > 0 else {
            Toast(text: "请输入联系电话").show()
            return
        }
        let model = JCommonContactModel()
        model.realName = realName
        model.type = type!
        model.idCardNumber = cardNum
        model.mobilePhone = phone
        JHUD.show(at: view)
        service.addCommonContact(model: model) {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result == true {
                NotificationCenter.default.post(name: Notification.Name("JCommonContacts"), object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }

}

extension JAddCommonContactViewController: JApplyActionPeopleViewDelegate {
    func choosePeople(_ view: JApplyActionPeopleView, type: String?) {
        let actionsheet = UIAlertController(title: "选择", message: nil, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "成人", style: .default, handler: {[weak self] (action) in
            self?.type = "man"
            self?.actionPeopleView.titleLabel.text = "成人"
        }))
        actionsheet.addAction(UIAlertAction(title: "老人", style: .default, handler: {[weak self] (action) in
            self?.type = "edler"
            self?.actionPeopleView.titleLabel.text = "老人"
        }))
        actionsheet.addAction(UIAlertAction(title: "小孩", style: .default, handler: {[weak self] (action) in
            self?.type = "child"
            self?.actionPeopleView.titleLabel.text = "小孩"
        }))
        actionsheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(actionsheet, animated: true) {
            
        }
    }
}
