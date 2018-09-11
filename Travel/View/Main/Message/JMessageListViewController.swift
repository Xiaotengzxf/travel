//
//  JMessageListViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class JMessageListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageALabel: UILabel!
    @IBOutlet weak var messageBLabel: UILabel!
    
    private let service = JMessageModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = searchBar.subviews.last?.subviews {
            for view in array {
                if let textfield = view as? UITextField {
                    textfield.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "f5f5f5")
                    textfield.layer.cornerRadius = 20
                    textfield.clipsToBounds = true
                }
            }
        }
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        service.getMessageList(page: 0,
                               keyboard: nil,
                               criteria: nil,
                               orderby: nil) { (result, message) in
            
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

extension JMessageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMessageListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension JMessageListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
}
