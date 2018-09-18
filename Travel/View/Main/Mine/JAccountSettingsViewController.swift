//
//  JAccountSettingsViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/28.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Kingfisher
import ALCameraViewController

class JAccountSettingsViewController: SCBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var row = 0
    private var value : String?
    private let titles = ["我的头像", "我的名称", "个人简介", "手机号码", "实名认证"]
    private var imageUrl: String?
    private var phone: String?
    private var userName: String?
    private var introduce: String?
    private let service = JAccountSettingsModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JEditAccountViewController {
            vc.intentData(value: value, isPhone: row == 3)
            vc.delegate = self
        }
    }

    @IBAction func save(_ sender: Any) {
        JHUD.show(at: self.view)
        service.updateAccount(icon: imageUrl, userName: userName, phone: phone, introduce: introduce) {[weak self] (result, message) in
            JHUD.hide(for: self!.view)
        }
    }
}

extension JAccountSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JAccountSettingsTableViewCell
        cell.nameLabel.text = titles[indexPath.row]
        cell.iconImageView.isHidden = indexPath.row != 0
        cell.iconImageView.layer.cornerRadius = 22.5
        cell.valueLabel.isHidden = indexPath.row == 0
        switch indexPath.row {
        case 1:
            cell.valueLabel.text = JUserManager.sharedInstance.user?.userName
        case 2:
            cell.valueLabel.text = JUserManager.sharedInstance.user?.introduce
        case 3:
            cell.valueLabel.text = JUserManager.sharedInstance.user?.mobilePhone
        default:
            if let icon = JUserManager.sharedInstance.user?.userIcon, icon.count > 0 {
                cell.iconImageView.kf.setImage(with: URL(string: icon)!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        switch indexPath.row {
        case 0:
            let cropping = CroppingParameters()
            let cameraViewController = CameraViewController(croppingParameters: cropping, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: false){ [weak self] image, asset in
                // Do something with your image here.
                let cell = self?.tableView.cellForRow(at: indexPath) as! JAccountSettingsTableViewCell
                cell.iconImageView.image = image
                if image != nil {
                    self?.service.uploadHeaderIcon(imageData: UIImageJPEGRepresentation(image!, 1)!){
                        (result, url) in
                        
                    }
                }
            }

            present(cameraViewController, animated: true, completion: nil)
        case 4:
            self.performSegue(withIdentifier: "Identification", sender: self)
        default:
            let cell = tableView.cellForRow(at: indexPath) as! JAccountSettingsTableViewCell
            value = cell.valueLabel.text
           self.performSegue(withIdentifier: "EditAccount", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 62
        } else {
            return 52
        }
    }
}

extension JAccountSettingsViewController: JEditAccountViewControllerDelegate {
    func refreshData(value: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! JAccountSettingsTableViewCell
        if row == 3 {
            let start = value.index(value.startIndex, offsetBy: 4)
            let end = value.index(value.startIndex, offsetBy: 8)
            let phone = value.replacingCharacters(in: start..<end, with: "****")
            cell.valueLabel.text = phone
        } else {
            cell.valueLabel.text = value
        }
        switch row {
        case 1:
            userName = value
        case 2:
            introduce = value
        default:
            phone = value
        }
    }
    
    
}
