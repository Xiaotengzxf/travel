//
//  JFAQPresenter.swift
//  Jouz
//
//  Created by doubll on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JFAQPresenter: NSObject {
    weak var viewDelegate: JFAQViewDelegate?
    var modelService: JFAQModelServiceDelegate?

    init(viewDelegate: JFAQViewDelegate) {
        super.init()
        self.viewDelegate = viewDelegate
        modelService = JFAQModelService(presenter: self)
    }
}

extension JFAQPresenter: JFAQPresenterDelegate {
    func requestFAQInfo() -> [FAQObj]? {
        return self.modelService?.requestFAQ(completion: {[weak self] (objs) in
            if let newObjs = objs as? [FAQObj] {
                self?.viewDelegate?.callbackFAQ(objs: newObjs)
            } else {
                self?.viewDelegate?.callbackFAQ(objs: nil)
            }
        })
    }

    func contactEvent() {
        let vc = (self.viewDelegate as! UIViewController)
        let optionv = JContactOptionView()
        optionv.leftClosure = {[weak optionv] in
            let feedback = JFeedbackViewController()
            vc.navigationController?.pushViewController(feedback, animated: true)
            optionv?.removeFromSuperview()
        }
        
        optionv.middleClosure = {[weak optionv] in
            optionv?.removeFromSuperview()
        }

        optionv.rightClosure = {[weak optionv] in
            let sb = UIStoryboard(name: "T9140", bundle: Bundle.main)
            let contactVC = sb.instantiateViewController(withIdentifier: "JCallUSViewController")
            vc.navigationController?.pushViewController(contactVC, animated: true)
            optionv?.removeFromSuperview()
        }

        optionv.cancelClosure = {[weak optionv] in
            optionv?.removeFromSuperview()
        }

        UIApplication.shared.keyWindow?.addSubview(optionv)
        optionv.snp.makeConstraints { (m) in
            m.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension UIView {
    func makeCorner(radius: CGFloat) {
        let bpath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = bpath.cgPath
        self.layer.mask = maskLayer
    }
}

class JContactOptionView: UIView {

    class JContactOption: UIView {
        lazy var leftButton: UIButton! = {
            let b = UIButton(type: .custom)
            b.backgroundColor = .white
            let img = UIImage(named: "help_icon_feedback")
            b.setImage(img, for: .normal)

            return b
        }()
        lazy var middleButton: UIButton! = {
            let b = UIButton(type: .custom)
            b.backgroundColor = .white
            let img = UIImage(named: "help_icon_chat")
            b.setImage(img, for: .normal)
            return b
        }()
        lazy var rightButton: UIButton! = {
            let b = UIButton(type: .custom)
            b.backgroundColor = .white
            let img = UIImage(named: "help_icon_call")
            b.setImage(img, for: .normal)
            return b
        }()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(leftButton)
            addSubview(middleButton)
            addSubview(rightButton)
            makeConstraints()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            leftButton.makeCorner(radius: 12)
            middleButton.makeCorner(radius: 12)
            rightButton.makeCorner(radius: 12)
        }

        func makeConstraints() {
            let topLabel = UILabel()
            topLabel.text = "cnn_help_contact".localized()
            topLabel.textColor = c3
            topLabel.font = t3
            addSubview(topLabel)
            topLabel.snp.makeConstraints { (m) in
                m.top.equalToSuperview().offset(10)
                m.centerX.equalToSuperview()
            }
            
            middleButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(topLabel.snp.bottom).offset(15)
                make.width.height.equalTo(60)
            }
            let middleLabel = UILabel()
            middleLabel.text = "Chat"
            middleLabel.font = t3
            middleLabel.textColor = c2
            addSubview(middleLabel)
            middleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(middleButton.snp.bottom).offset(8)
                m.centerX.equalTo(middleButton)
                m.bottom.equalToSuperview().offset(-22)
            }

            leftButton.snp.makeConstraints { (make) in
                make.right.equalTo(middleButton.snp.left).offset(-54 * scale)
                make.top.equalTo(topLabel.snp.bottom).offset(15)
                make.width.height.equalTo(60)
            }
            let leftLabel = UILabel()
            leftLabel.text = "cnn_help_feedback".localized()
            leftLabel.font = t3
            leftLabel.textColor = c2
            addSubview(leftLabel)
            leftLabel.snp.makeConstraints { (m) in
                m.top.equalTo(leftButton.snp.bottom).offset(8)
                m.centerX.equalTo(leftButton)
            }

            rightButton.snp.makeConstraints { (make) in
                make.left.equalTo(middleButton.snp.right).offset(54 * scale)
                make.top.equalTo(topLabel.snp.bottom).offset(15)
                make.width.height.equalTo(60)
            }

            let rightLabel = UILabel()
            rightLabel.text = "cnn_help_call".localized()
            rightLabel.font = t3
            rightLabel.textColor = c2
            addSubview(rightLabel)
            rightLabel.snp.makeConstraints { (m) in
                m.top.equalTo(rightButton.snp.bottom).offset(8)
                m.centerX.equalTo(rightButton)
            }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        optionView.makeCorner(radius: 12)
        cancelButton.makeCorner(radius: 12)
    }

    lazy var optionView: JContactOption! = {
        let v = JContactOption()
        v.backgroundColor = c6
        return v
    }()
    lazy var cancelButton: UIButton! = {
        let b = UIButton(type: .custom)
        b.setTitle("common_cancel".localized(), for: .normal)
        b.setTitleColor(c1, for: .normal)
        b.titleLabel?.font = t2
        b.backgroundColor = .white
        return b
    }()

    @objc func leftEvent() {
        leftClosure?()
    }
    
    @objc func middleEvent() {
        middleClosure?()
    }

    @objc func rightEvent() {
        rightClosure?()
    }

    @objc func cancelEvent() {
        cancelClosure?()
    }


    var leftClosure: (()->Void)?
    var middleClosure: (()->Void)?
    var rightClosure: (()->Void)?
    var cancelClosure: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(optionView)
        addSubview(cancelButton)

        optionView.leftButton.addTarget(self, action: #selector(leftEvent), for: .touchUpInside)
        optionView.middleButton.addTarget(self, action: #selector(middleEvent), for: .touchUpInside)
        optionView.rightButton.addTarget(self, action: #selector(rightEvent), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        makeConstraints()
    }

    func makeConstraints() {
        cancelButton.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(54)
        }
        optionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



