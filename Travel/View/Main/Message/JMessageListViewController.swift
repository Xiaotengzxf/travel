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
    private var arrData: [Message] = []
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
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            self?.page = 1
            self?.downloadData()
        })
        tableView.mj_footer = MJRefreshBackFooter(refreshingBlock: {
            [weak self] in
            self?.page += 1
            self?.downloadData()
        })
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //searchBar.subviews.last?.subviews.forEach{print($0.frame)}
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
        service.getMessageList(page: page,
                               keyboard: keyboard,
                               criteria: criteria,
                               orderby: orderby) {[weak self] (result, message) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            if let arr = result {
                self?.emptyShow = 0
                if arr.count > 0 {
                    if self!.page == 1 {
                        self?.arrData.removeAll()
                    }
                    self?.arrData += arr
                    self?.tableView.reloadData()
                } else {
                    if self!.page == 1 {
                        self?.arrData.removeAll()
                        self?.emptyShow = 2
                    }
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

}

extension JMessageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMessageListTableViewCell
        let item = arrData[indexPath.row]
        cell.iconImageView.backgroundColor = UIColor.red
        cell.titleLabel.text = item.title
        cell.messageLabel.text = item.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension JMessageListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return emptyShow > 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "404")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "网页丢失，再刷新试试~", attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "999999")])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return ZColorManager.sharedInstance.colorWithHexString(hex: "f5f5f5")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        return NSAttributedString(string: "刷新", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "29A1F7")])
    }
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> UIImage? {
        return UIImage(named: "button_bg")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -50
    }
}
