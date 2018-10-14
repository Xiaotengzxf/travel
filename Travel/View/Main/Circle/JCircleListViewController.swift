//
//  JCircleListViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import MJRefresh
import Toaster
import SDWebImage

class JCircleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let service = JCircleModelService()
    private var keyboard : String?
    private var criteria : String?
    private var orderby: String?
    private var arrData: [Circle] = []
    private var emptyShow = 0
    private var popVc: PopViewController!
    private var circleId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = searchBar.subviews.last?.subviews {
            for view in array {
                if let textfield = view as? UITextField {
                    textfield.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "f5f5f5")
                    textfield.layer.cornerRadius = 18
                    textfield.clipsToBounds = true
                }
            }
        }
        searchBar.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.white), for: .any, barMetrics: .default)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            //self?.page = 0
            self?.downloadData()
        })
//        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            [weak self] in
//            self?.page += 1
//            self?.downloadData()
//        })
//        tableView.mj_footer.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: Notification.Name("JCircleListViewController"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleNotification(notification: Notification) {
        if let obj = notification.object as? String {
            if obj == kA {
                if let viewController = storyboard?.instantiateViewController(withIdentifier: "JCircleDetailViewController") as? JCircleDetailViewController {
                    viewController.intent(id: circleId)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            } else if obj == kB {
                if let viewController = storyboard?.instantiateViewController(withIdentifier: "JMyCollectViewController") as? JMyCollectViewController {
                    viewController.intent(id: circleId)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// 初始化，添加圈子通知
    private func initialTableData() {
        let circle = Circle()
        circle.id = "0"
        arrData = [circle]
    }
    
    private func downloadData() {
        service.getCircleList() {
            [weak self] (result, message) in
            self?.tableView.mj_header.endRefreshing()
            //self?.tableView.mj_footer.endRefreshing()
            if let arr = result {
                self?.emptyShow = 0
                if arr.count > 0 {
                    //if self!.page == 0 {
                        self?.initialTableData()
//                        if arr.count < 20 {
//                            self?.tableView.mj_footer.endRefreshingWithNoMoreData()
//                        }
                    //}
                    self?.arrData += arr
                    self?.tableView.reloadData()
                } else {
                    //if self!.page == 0 {
                        self?.initialTableData()
                        //self?.emptyShow = 2
                    //}
                    self?.tableView.reloadData()
                }
            } else {
                if let msg = message {
                    if msg == "\(kErrorNetworkOffline)" {
                        if self?.arrData.count == 0 {
                            self?.emptyShow = 1
                            self?.tableView.reloadData()
                        } else {
                            Toast(text: "网络故障，请检查网络").show()
                        }
                    } else {
                    Toast(text: msg).show()
                    }
                }
            }
        }
    }
    
    private func modalPopView(type: PopViewType) {
        let animationDelegate = PopoverAnimation()
        popVc = PopViewController()
        popVc.popType = type
        popVc.transitioningDelegate = animationDelegate
        popVc.modalPresentationStyle = .custom
        popVc.selectDelegate = self
        animationDelegate.popViewType = type
        present(popVc, animated: true, completion: nil)
        
    }
    
    @IBAction func addCircle(_ sender: Any) {
        modalPopView(type: .right)
    }
    
}

extension JCircleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMessageListTableViewCell
        if indexPath.row == 0 {
            cell.iconImageView.image = UIImage(named: "icon")
            cell.titleLabel.text = "圈子通知"
            cell.messageLabel.text = nil
        } else {
            let circle = arrData[indexPath.row]
            cell.titleLabel.text = circle.name
            cell.messageLabel.text = circle.description
            if let url = circle.imageUrl, url.count > 0 {
                cell.iconImageView?.sd_setImage(with: URL(string: url))
            } else {
                cell.iconImageView?.image = UIImage(named: "icon_2")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "JCircleNotificationViewController") as? JCircleNotificationViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            let circle = arrData[indexPath.row]
            if let id = circle.chatGroupId, id.count > 0 {
                let userId = JUserManager.sharedInstance.user?.userId ?? ""
                if circle.type == "audit" && circle.ownerUserId != userId {
                    service.circelJoin(circleId: id) {[weak self] (result, message) in
                        if result {
                            let conversation = EaseMessageViewController(conversationChatter: id, conversationType: EMConversationTypeGroupChat)
                            conversation?.serverId = circle.id
                            self?.circleId = circle.id ?? ""
                            conversation?.hidesBottomBarWhenPushed = true
                            conversation?.title = circle.name ?? "聊天"
                            self?.navigationController?.pushViewController(conversation!, animated: true)
                        }
                    }
                } else {
                    let conversation = EaseMessageViewController(conversationChatter: id, conversationType: EMConversationTypeGroupChat)
                    conversation?.serverId = circle.id
                    self.circleId = circle.id ?? ""
                    conversation?.hidesBottomBarWhenPushed = true
                    conversation?.title = circle.name ?? "聊天"
                    self.navigationController?.pushViewController(conversation!, animated: true)
                }
            }
        }
    }
}

extension JCircleListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return emptyShow > 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: emptyShow == 1 ? "404" : "404_2")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: emptyShow == 1 ? "网页丢失，再刷新试试~" : "阿哦，什么东西都没有耶~", attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "999999")])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return ZColorManager.sharedInstance.colorWithHexString(hex: "f5f5f5")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        return emptyShow == 1 ? NSAttributedString(string: "刷新", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7")]) : nil
    }
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> UIImage? {
        return emptyShow == 1 ? UIImage(named: "button_bg") : nil
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return emptyShow == 1 ? -50 : -30
    }
}

extension JCircleListViewController: DidSelectPopViewCellDelegate {
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        popVc?.dismiss(animated: true, completion: {
            
        })
        if indexPath.row == 0 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "JCCreateCircleViewController") as? JCCreateCircleViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
