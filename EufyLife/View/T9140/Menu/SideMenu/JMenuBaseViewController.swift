//
//  JMenuBaseViewController.swift
//  Jouz
//
//  Created by doubll on 2018/4/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMenuBaseViewController: SCLocalizedViewController {
    final private(set) var titleView: UILabel?

    var titleKey: String = "" {
        didSet {
            makeTitle()
        }
    }

    func makeTitle() {
        titleView?.text = titleKey.localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        makeTitle()
        sendScreenView()
    }

    /// 生成ui相关
    func makeUI() {
        makeTitleView()
        makeConstraints()
    }

    /// 重写方法决定子类有没有titleView
    ///
    /// - Returns: 有没有titleView
    func needTitleView() -> Bool {
        return true
    }

    override func reloadText() {
        super.reloadText()
        makeTitle()
    }

   private func makeConstraints() {
        if let titleLabel = self.titleView {
            view.addSubview(titleLabel)
            titleLabel.textAlignment = .left
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
                } else {
                    make.top.equalTo(topLayoutGuide.snp.bottom).offset(2)
                }
                make.height.equalTo(40)
            }
            titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    }

    /// 生成titleView
   private func makeTitleView() {
        if needTitleView() {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = t1
            titleLabel.backgroundColor = .clear
            self.titleView = titleLabel
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
