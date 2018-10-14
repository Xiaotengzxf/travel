//
//  JPublishCircleCViewController.swift
//  Travel
//
//  Created by ANKER on 2018/10/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JPublishCircleCViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var customActionInfoButton: UIButton!
    @IBOutlet weak var circleListView: UIView!
    @IBOutlet weak var headViewHeightLConstraint: NSLayoutConstraint!
    @IBOutlet weak var circleListViewHeightLConstraint: NSLayoutConstraint!
    
    private let service = JPublishCircleModelService()
    private var value: [String : Any] = [:]
    private var actionCount = 1
    private var circleCount = 0
    private var circles: [Circle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JHUD.show(at: self.view)
        service.downloadAllCircle {[weak self] (circles, message) in
            JHUD.hide(for: self!.view)
            if circles != nil {
                if let array = circles, array.count > 0 {
                    self?.circles = array
                    for (index, item) in array.enumerated() {
                        if let circleInfoView = Bundle.main.loadNibNamed("JCircleInfoView", owner: nil, options: nil)?.first as? JCircleInfoView {
                            circleInfoView.translatesAutoresizingMaskIntoConstraints = false
                            circleInfoView.tag = 1000 + index
                            circleInfoView.button.setTitle(item.name ?? "", for: .normal)
                            self?.circleListView.addSubview(circleInfoView)
                            
                            self?.circleListView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[circleInfoView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["circleInfoView" : circleInfoView]))
                            self?.circleListView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[circleInfoView(52)]", options: .directionLeadingToTrailing, metrics: ["top" : index * 52], views: ["circleInfoView" : circleInfoView]))
                        }
                    }
                    self?.circleCount = array.count
                    self?.circleListViewHeightLConstraint.constant = CGFloat(52 * array.count)
                }
            } else {
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
        
        if let actionInfoView = Bundle.main.loadNibNamed("JActionInfoView", owner: nil, options: nil)?.first as? JActionInfoView {
            actionInfoView.translatesAutoresizingMaskIntoConstraints = false
            actionInfoView.tag = 100
            headView.addSubview(actionInfoView)
            
            headView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[actionInfoView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["actionInfoView" : actionInfoView]))
            headView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[actionInfoView(276)]", options: .directionLeadingToTrailing, metrics: nil, views: ["actionInfoView" : actionInfoView]))
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JActionDetailViewController {
            var array : [[String: String]] = []
            for i in 0..<actionCount {
                let actionInfoView = headView.viewWithTag(100 + i) as! JActionInfoView
                let title = actionInfoView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let content = actionInfoView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let action = ["content": content, "title": title]
                array.append(action)
            }
            value["activityInfoList"] = array
            
            var ids : [String] = []
            for i in 0..<circleCount {
                let circleInfoView = circleListView.viewWithTag(1000+i) as! JCircleInfoView
                if circleInfoView.button.isSelected {
                    ids.append(circles[i].id ?? "")
                }
            }
            if ids.count == 0 {
                Toast(text: "请选择发布的圈子").show()
                return
            }
            value["circleIdList"] = ids
            vc.intent(value: value)
        }
    }
    
    // MARK: - Public
    
    public func intent(value: [String : Any]) {
        self.value = value
    }
    
    @IBAction func addCustomActionInfo(_ sender: Any) {
        if let actionInfoView = Bundle.main.loadNibNamed("JActionInfoView", owner: nil, options: nil)?.first as? JActionInfoView {
            actionInfoView.translatesAutoresizingMaskIntoConstraints = false
            actionInfoView.tag = 100 + actionCount
            headView.addSubview(actionInfoView)
            
            headView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[actionInfoView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["actionInfoView" : actionInfoView]))
            headView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[actionInfoView(276)]", options: .directionLeadingToTrailing, metrics: ["top": 276 * actionCount], views: ["actionInfoView" : actionInfoView]))
            
            actionCount += 1
            
            headViewHeightLConstraint.constant = CGFloat(276 * actionCount)
        }
    }
}
