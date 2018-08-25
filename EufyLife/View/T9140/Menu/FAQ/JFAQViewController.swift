//
//  JFAQViewController.swift
//  Jouz
//
//  Created by doubll on 2018/4/25.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

private let kJFAQViewControllerReuseIdentifier = "kJFAQViewControllerReuseIdentifier"

extension JFAQViewController: JFAQViewDelegate {
    func callbackFAQ(objs: [FAQObj]?) {
        hideHUD()
        if objs != nil {
            self.faqObjs = objs!
            self.tableview.reloadData()
        }
    }
}

class JFAQViewController: JMenuBaseViewController {
    var presenter: JFAQPresenterDelegate?
    var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FAQ"
        view.clipsToBounds = true
        self.presenter = JFAQPresenter(viewDelegate: self)
        showHUD()
        if let faq = self.presenter?.requestFAQInfo() {
            self.faqObjs = faq
            self.tableview.reloadData()
        }
        sendScreenView()
    }

    override func makeUI() {
        super.makeUI()
        makeFAQContainerView()
    }

    lazy var contactButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("cnn_help_contact".localized(), for: .normal)
        btn.addTarget(self, action: #selector(contactEvent), for: .touchUpInside)
        return btn
    }()

    @objc func contactEvent() {
        presenter?.contactEvent()
    }

    func makeFAQContainerView() {
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.backgroundColor = .clear
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.clipsToBounds = true

        /// 自动计算行高
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 88
        /// 自动计算行高
        tableview.sectionHeaderHeight = 90
        tableview.register(JUserPortfolioImageCell.self, forCellReuseIdentifier: kJFAQViewControllerReuseIdentifier)
        view.addSubview(tableview)
        view.addSubview(contactButton)
        contactButton.setBackground(size: CGSize(width: screenWidth - 80, height: 54), cornerRadius: 27, addShadow: false)
        contactButton.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(40)
            m.right.equalToSuperview().offset(-40)
            m.height.equalTo(54)
            m.bottom.equalToSuperview().offset(-30)
        }

        tableview.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    deinit {
        logInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate var faqObjs: [FAQObj]?
}

class FAQObj: NSObject, NSCoding {
    
    var hidden: Bool = true
    var question: String = ""
    var answer: String = ""
    
    init(hidden: Bool, question: String, answer: String) {
        super.init()
        self.hidden = hidden
        self.question = question
        self.answer = answer
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hidden, forKey: "hidden")
        aCoder.encode(question, forKey: "question")
        aCoder.encode(answer, forKey: "answer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        hidden = aDecoder.decodeBool(forKey: "hidden")
        question = aDecoder.decodeObject(forKey: "question") as? String ?? ""
        answer = aDecoder.decodeObject(forKey: "answer") as? String ?? ""
    }
}

extension JFAQViewController: UITableViewDelegate {

    @objc private  func didSelectedHeaderAt(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            if let obj = faqObjs?[view.tag] {
                obj.hidden = !obj.hidden
            }
            self.tableview.reloadData()
        }
    }
}

extension JFAQViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = makeQuestionView(for: section)
        v.lowerLine.isHidden = true
        if let obj = faqObjs?[section] {
            if obj.hidden {
                v.rightImage = UIImage(named: "sidemenu_icon_arrowup")
                /// 最后一行且内容不显示的时候才显示下方的线
                if (section == (faqObjs!.count - 1)) {v.lowerLine.isHidden = false}
            } else {
                v.rightImage = UIImage(named: "sidemenu_icon_arrowdown")
            }
            v.leftTxt = obj.question
        }

        return v
    }

    func makeQuestionView(for section: Int) -> JUserPortfolioImageCell {
        let v = JUserPortfolioImageCell(frame: .zero)
        v.rightImgView.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectedHeaderAt(tap:)))
        v.addGestureRecognizer(tap)
        v.tag = section
        v.upperLine.isHidden = false
        v.lowerLine.isHidden = true
        return v
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.faqObjs?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let obj = faqObjs?[section] {
            if obj.hidden {return 0} else {return 1}
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: kJFAQViewControllerReuseIdentifier, for: indexPath) as! JUserPortfolioImageCell

        cell.leftLabel.snp.removeConstraints()
        cell.leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-33)
            make.right.equalToSuperview().offset(-40)
        }

        /// 最后一个显示线
        cell.lowerLine.isHidden = (indexPath.section != (faqObjs!.count - 1))
        cell.leftLabel.font = ZFontManager.sharedInstance.getFont(type: .medium, size: 14)
        cell.backgroundColor = .clear
        if let obj = faqObjs?[indexPath.section] {
            cell.leftTxt = "\(obj.answer)"
        }
        return cell
    }
}

class JUserPortfolioBaseCell: UITableViewCell {
    
    var isTopOne: Bool = false {
        didSet {upperLine.isHidden = !isTopOne}
    }
    
    private(set) var upperLine = CellLineView.init(position: .upper)
    private(set) var lowerLine = CellLineView.init(position: .lower)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        upperLine.backgroundColor = c6
        lowerLine.backgroundColor = c6
        contentView.add(line: upperLine, offset: kPaddingLeft)
        contentView.add(line: lowerLine, offset: kPaddingLeft)
        
        upperLine.isHidden = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JUserPortfolioImageCell: JUserPortfolioBaseCell {
    private(set) lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "80848f")
        label.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var rightImgView: UIImageView! = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    var leftTxt: String = "" {
        didSet {
            self.leftLabel.text = leftTxt
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            self.rightImgView.image = rightImage
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightImgView)
        rightImgView.isHidden = true
        makeConstraints()
    }
    
    private func makeConstraints() {
        rightImgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(12)
            make.width.equalTo(20)
            make.top.equalToSuperview().offset(30)
        }
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImgView.snp.left).offset(-35)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
