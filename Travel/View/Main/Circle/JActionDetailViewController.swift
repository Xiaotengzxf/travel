//
//  JActionDetailViewController.swift
//  Travel
//
//  Created by ANKER on 2018/11/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster
import SDWebImage

class JActionDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var footView: UIView!
    @IBOutlet weak var footBView: UIView!
    @IBOutlet weak var footTitleLabel: UILabel!
    @IBOutlet weak var footDescLabel: UILabel!
    @IBOutlet weak var applyView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    private var value: [String : Any] = [:]
    private var activity: Activity!
    private var activityId: String?
    private let titles = ["活动地址", "活动时间", "退出\n截止时间", "活动人数"]
    private var service = JPublishActionModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityId != nil {
            JHUD.show(at: self.view)
            service.getActionDetail(activityId: activityId ?? "") {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result != nil {
                    self?.activity = result
                    self?.refreshUIA()
                    self?.tableView.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        } else {
            applyView.isHidden = true
            refreshUIB()
        }
        
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth * 443 / 750 + 97)
        
    }
    
    private func refreshUIA() {
        headImageView.backgroundColor = UIColor.lightGray
        if let url = activity.imageUrl, url.hasPrefix("http") {
            headImageView.sd_setImage(with: URL(string: url))
        }
        titleLabel.text = "【周四】\(activity.city ?? "").\(activity.district ?? "").\(activity.title ?? "")"
        let fee = activity.fee ?? 0
        feeLabel.text = "¥\(fee)"
        let description = activity.description ?? ""
        descLabel.text = description
        
        let array = activity.activityInfoList
        footTitleLabel.text = array?[0].title ?? ""
        footDescLabel.text = array?[0].content ?? ""
        
        favoriteButton.setImage(UIImage(named: activity.isFavorite == true ? "star" : "star_2"), for: .normal)
    }
    
    private func refreshUIB() {
        headImageView.backgroundColor = UIColor.lightGray
        if let url = value["imageUrl"] as? String, url.hasPrefix("http") {
            headImageView.sd_setImage(with: URL(string: url))
        }
        let title = value["title"] as? String ?? ""
        //let subTitle = value["subTitle"] as? String ?? ""
        //let gather = value["activityGather"] as? [String : String] ?? [:]
        //let provice = gather["province"] ?? ""
        let district = value["district"] ?? ""
        let city = value["city"] ?? ""
        //let addressDetail = gather["addressDetail"] ?? ""
        titleLabel.text = "【周日】\(city)·\(district)·\(title)"
        let fee = value["fee"] ?? ""
        feeLabel.text = "¥\(fee)"
        let description = value["description"] as? String ?? ""
        descLabel.text = description
        
        let array = value["activityInfoList"] as? [[String : String]] ?? []
        footTitleLabel.text = array[0]["title"] ?? ""
        footDescLabel.text = array[0]["content"] ?? ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func intent(value: [String : Any]) {
        self.value = value
    }
    
    public func intent(value: String) {
        self.activityId = value
    }

    @IBAction func publishAction(_ sender: Any) {
        JHUD.show(at: self.view)
        service.publishCircle(value: value) {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result {
                self?.navigationController?.popToRootViewController(animated: true)
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }
    @IBAction func collectionAction(_ sender: Any) {
        JHUD.show(at: self.view)
        if (self.activity.isFavorite) ?? false {
            service.unfavoriteCircle(activityId: activity.id ?? "") {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result {
                    Toast(text: "取消收藏成功").show()
                    self?.favoriteButton.setImage(UIImage(named: "star_2"), for: .normal)
                    self?.activity.isFavorite = false
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        } else {
            service.favoriteCircle(activityId: activity.id ?? "") {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result {
                    Toast(text: "收藏成功").show()
                    self?.favoriteButton.setImage(UIImage(named: "star"), for: .normal)
                    self?.activity.isFavorite = true
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
    }
    
    @IBAction func applyAAction(_ sender: Any) {
        if activity != nil {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "JApplyActionViewController") as? JApplyActionViewController {
                viewController.intentData(activity: activity)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension JActionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityId != nil {
            return activity != nil ? 4 : 0
        } else {
            return 4
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = titles[indexPath.row]
        }
        if let label = cell.viewWithTag(2) as? UILabel {
            switch indexPath.row {
            case 0:
                if activity != nil {
                    let gather = activity.activityGatherList?[0]
                    let provice = gather?.province ?? ""
                    let district = gather?.district ?? ""
                    let city = gather?.city ?? ""
                    label.text = "\(provice) \(city) \(district)"
                } else {
                    let gather = value["activityGather"] as? [String : String] ?? [:]
                    let provice = gather["province"] ?? ""
                    let district = gather["district"] ?? ""
                    let city = gather["city"] ?? ""
                    label.text = "\(provice) \(city) \(district)"
                }
            case 1:
                if activity != nil {
                    let startTime = activity.startTime ?? ""
                    let endTime = activity.endTime ?? ""
                    label.text = "\(startTime)至\(endTime)"
                } else {
                    let startTime = value["startTime"] as? String ?? ""
                    let endTime = value["endTime"] as? String ?? ""
                    label.text = "\(startTime)至\(endTime)"
                }
            case 2:
                if activity != nil {
                    let outStartTime = activity.enterDeadline ?? ""
                    label.text = "\(outStartTime)"
                } else {
                    let outStartTime = value["enterDeadline"] as? String ?? ""
                    label.text = "\(outStartTime)"
                }
            case 3:
                if activity != nil {
                    let num = activity.enterMaxNumber ?? 0
                    label.text = "已报名0人/限报名\(num)人"
                } else {
                    let num = value["enterMaxNumber"] as? Int ?? 0
                    label.text = "已报名0人/限报名\(num)人"
                }
            default:
                print("error")
            }
            
        }
        if let label = cell.viewWithTag(3) as? UILabel {
            if indexPath.row == 2 {
                label.text = "退出截止时间之前，可退款"
            } else {
                label.text = nil
            }
        }
        return cell
    }
}
