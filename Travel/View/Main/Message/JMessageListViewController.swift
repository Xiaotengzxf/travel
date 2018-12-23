//
//  JMessageListViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import MJRefresh
import Kingfisher
import Toaster

class JMessageListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageALabel: UILabel!
    @IBOutlet weak var messageBLabel: UILabel!
    
    private let service = JMessageModelService()
    private var page = 1
    private var keyboard : String?
    private var criteria : String?
    private var orderby: String?
    private var tableData: [Circle] = []
    private var emptyShow = 0
    
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
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            self?.page = 0
            self?.downloadData()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [weak self] in
            self?.page += 1
            self?.downloadData()
        })
        tableView.mj_footer.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.mj_header.beginRefreshing()
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
    
    private func downloadData() {
//        service.getMessageList(page: page,
//                               keyboard: keyboard,
//                               criteria: criteria,
//                               orderby: orderby) {[weak self] (result, message) in
//            self?.tableView.mj_header.endRefreshing()
//            self?.tableView.mj_footer.endRefreshing()
//            if let arr = result {
//                self?.emptyShow = 0
//                if arr.count > 0 {
//                    if self!.page == 1 {
//                        self?.arrData.removeAll()
//                        self?.tableView.mj_footer.isHidden = arr.count >= 20
//                    }
//                    self?.arrData += arr
//                    self?.tableView.reloadData()
//                } else {
//                    if self!.page == 1 {
//                        self?.arrData.removeAll()
//                        self?.emptyShow = 2
//                    }
//                    self?.tableView.reloadData()
//                }
//            } else {
//                if let msg = message {
//                    if msg == "\(kErrorNetworkOffline)" {
//                        if self?.arrData.count == 0 {
//                            self?.emptyShow = 1
//                            self?.tableView.reloadData()
//                        } else {
//                            Toast(text: "网络故障，请检查网络").show()
//                        }
//                    } else {
//                        Toast(text: msg).show()
//                    }
//                }
//            }
//        }
        service.getCircleList {[weak self] (result, message) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.tableData.removeAll()
            if let data = result {
                self?.tableData = data
            }
            self?.tableView.reloadData()
            if message != nil {
                Toast(text: message!).show()
            }
        }
        
    }

}

extension JMessageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMessageListTableViewCell
        let item = tableData[indexPath.row]
        cell.titleLabel.text = item.name
        cell.messageLabel.text = item.description
        if let imageIcon = item.imageUrl, imageIcon.hasPrefix("http") {
            cell.iconImageView.kf.setImage(with: URL(string: imageIcon))
        } else {
            cell.iconImageView.image = UIImage(named: "icon_2")
        }
        
        cell.numLabel.text = "\(1)"
        //cell.timeLabel.text = Int(item.latestMessage.timestamp).toTime()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let circle = tableData[indexPath.row]
        if let id = circle.chatGroupId, id.count > 0 {
            let userId = JUserManager.sharedInstance.user?.userId ?? ""
            if circle.type == "audit" && circle.ownerUserId != userId {
                let conversation = JChatViewController(conversationChatter: id, conversationType: EMConversationTypeGroupChat)
                conversation?.serverId = circle.id
                conversation?.hidesBottomBarWhenPushed = true
                conversation?.title = circle.name ?? "聊天"
                self.navigationController?.pushViewController(conversation!, animated: true)
            } else {
                let conversation = JChatViewController(conversationChatter: id, conversationType: EMConversationTypeGroupChat)
                conversation?.serverId = circle.id
                conversation?.hidesBottomBarWhenPushed = true
                conversation?.title = circle.name ?? "聊天"
                self.navigationController?.pushViewController(conversation!, animated: true)
            }
        }
        
        
    }
}

extension JMessageListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
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
