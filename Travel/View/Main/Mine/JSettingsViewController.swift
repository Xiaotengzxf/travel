//
//  JSettingsViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/26.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    private let titles = ["账号设置", "推送设置", "使用指导", "意见反馈", "清理缓存"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        logOutButton.layer.borderWidth = 0.5
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

    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: kPhone)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "JRootNavigationController") as? JRootNavigationController {
            self.view.window?.rootViewController = navigationController
            self.navigationController?.viewControllers = []
            let error = EMClient.shared()?.logout(true)
            print("环信退出登录: \(error?.description ?? "成功")")
            JUserManager.sharedInstance.logout()
        }
    }
    
    @objc private func switchValueChanged(_ sender: Any) {
        if let s = sender as? UISwitch {
            print(s.isOn)
        }
    }
}

extension JSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        if indexPath.row == 4 {
            cell.detailTextLabel?.text = "6M"
        } else {
            cell.detailTextLabel?.text = nil
        }
        if indexPath.row == 1 {
            let s = UISwitch()
            s.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = s
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "AccountSettings", sender: self)
        case 3:
            self.performSegue(withIdentifier: "Feedback", sender: self)
        default:
            print("TODO")
        }
    }
}
