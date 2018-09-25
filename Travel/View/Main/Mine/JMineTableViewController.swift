//
//  JMineTableViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/26.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class JMineTableViewController: UITableViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var attentionNumLabel: UILabel!
    @IBOutlet weak var fansNumLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    private let titles = ["我的订单", "我的相册", "我的收藏", "保险", "联系客服"]
    private let service = JMineModelService()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let icon = JUserManager.sharedInstance.user?.userIcon, icon.count > 0 {
            iconImageView.kf.setImage(with: URL(string: icon)!)
        }
        nameLabel.text = JUserManager.sharedInstance.user?.userName
        signLabel.text = JUserManager.sharedInstance.user?.introduce
        idLabel.text = "ID: \(JUserManager.sharedInstance.user?.userId ?? "")"
        
        service.getFocus(page: 0, keyboard: nil, criteria: nil, orderby: nil) { (result, message) in
            
        }
        
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 240)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAttention(_ sender: Any) {
        
    }
    
    @IBAction func showFan(_ sender: Any) {
        self.performSegue(withIdentifier: "MyFan", sender: self)
    }
    
    private func showInsurace() {
        let url = URL(string: "https://www.baidu.com")
        let safariVC = SFSafariViewController(url: url!)
        self.navigationController?.tabBarController?.present(safariVC, animated: true, completion: {
            
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "333333")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "MyOrder", sender: self)
        case 1:
            self.performSegue(withIdentifier: "MyPhoto", sender: self)
        case 2:
            self.performSegue(withIdentifier: "MyCollection", sender: self)
        case 3:
            showInsurace()
        case 4:
            self.performSegue(withIdentifier: "Contact", sender: self)
        default:
            print("TODO")
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

}
