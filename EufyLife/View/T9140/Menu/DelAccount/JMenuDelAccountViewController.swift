//
//  JMenuDelAccountViewController.swift
//  Jouz
//
//  Created by doubll on 2018/6/4.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMenuDelAccountViewController: JMenuBaseViewController {

   lazy var alertImageView: UIImageView = {
        let img = UIImage(named: "delete_account_img_alert")
        let imgv = UIImageView(image: img)
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()

   lazy var alertLabel: UILabel = {
        let l = UILabel()
        l.font = t3
        l.textColor = c3
        l.numberOfLines = 0
        return l
    }()

    lazy var deleteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("cnn_del_account".localized(), for: .normal)
        b.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)
        return b
    }()

    var deleteClosure: (()->Void)?

    @objc func deleteEvent() {
        deleteClosure?()
    }

    deinit {
        logInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleKey = "cnn_del_account".localized()
        self.alertLabel.text = "cnn_del_account_tips".localized().replacingOccurrences(of: "^^", with: "\n\n")
        sendScreenView()
    }

    override func makeUI() {
        super.makeUI()
        view.addSubview(alertImageView)
        view.addSubview(alertLabel)
        view.addSubview(deleteButton)
        makeConstraints()
    }

    func makeConstraints() {
        if let titleView = titleView {
            alertImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
            alertImageView.snp.makeConstraints({ (make) in
                make.top.equalTo(titleView.snp.bottom).offset(64)
                make.centerX.equalToSuperview()
            })

            alertLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            alertLabel.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(kPaddingLeft)
                make.centerX.equalToSuperview()
                make.top.equalTo(alertImageView.snp.bottom).offset(65)
            })

            deleteButton.snp.makeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
                } else {
                    make.bottom.equalToSuperview().offset(-32)
                }
                make.left.right.equalTo(alertLabel)
                make.height.equalTo(48)
                make.top.greaterThanOrEqualTo(alertLabel.snp.bottom).offset(kPaddingTop).priority(.high)
            })
        }
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

}
