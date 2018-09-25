//
//  JMyCollectViewController.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyCollectViewController: UIViewController {

    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBttuon: UIButton!
    @IBOutlet weak var tableViewBottomLConstraint: NSLayoutConstraint!
    
    private let service = JMyCollectionModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBttuon.isHidden = true
        
        service.getFavorite(page: 0, keyboard: nil, criteria: nil, orderby: nil) { (result, message) in
            
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

    @IBAction func editCollection(_ sender: Any) {
        if editBarButtonItem.title == "编辑" {
            editBarButtonItem.title = "完成"
            deleteBttuon.isHidden = false
            tableViewBottomLConstraint.constant = -50
        } else {
            editBarButtonItem.title = "编辑"
            deleteBttuon.isHidden = true
            tableViewBottomLConstraint.constant = 0
        }
        
        tableView.reloadData()
    }
    
    @IBAction func deleteCollection(_ sender: Any) {
        
    }
}

extension JMyCollectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMyCollectTableViewCell
        cell.showLeftView(value: editBarButtonItem.title == "完成")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
