//
//  JSideMenuViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/10.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JSideMenuViewController: SCBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet var lineImageViews: [UIImageView]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addDeviceImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    private var presenter: JSideMenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = JSideMenuPresenter(viewDelegate: self)
        setSubViewPropertyValue()
        refreshData()
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
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        
        for imageView in lineImageViews {
            imageView.backgroundColor = c6
        }
        
        logoutButton.setTitleColor(c8, for: .normal)
        logoutButton.titleLabel?.font = t3
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.cornerRadius = 27
        logoutButton.backgroundColor = c9
        
        versionLabel.textColor = c3
        versionLabel.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 12)
        versionLabel.text = "App Version 2.1"
        
        copyRightLabel.textColor = c4
        copyRightLabel.font = ZFontManager.sharedInstance.getFont(type: .regular, size: 12)
        copyRightLabel.text = "Copyright @ 2018 Anker"
        
        headerImageView.image = UIImage(named: "setting_icon_adavater1")
        nameLabel.textColor = c1
        nameLabel.font = t2
        emailLabel.textColor = c2
        emailLabel.font = t4
        headLabel.textColor = c8
        headLabel.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 20)
        
        userInfoLabel.textColor = c3
        userInfoLabel.font = t5
        
        memberLabel.textColor = c2
        memberLabel.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 18)
        memberLabel.text = "Family Members"
        
        addDeviceImageView.image = UIImage(named: "more_icon_scale")
        deviceNameLabel.textColor = c2
        deviceNameLabel.font = t3
        deviceNameLabel.text = "Add Device"
        
        editButton.setTitleColor(c1, for: .normal)
        editButton.titleLabel?.font = t4
        editButton.setTitle("Edit", for: .normal)
    }
    
    private func refreshData() {
        emailLabel.text = presenter.getEmail()
        if let name = presenter.getMemberInfo(row: -1).name {
            nameLabel.text = name
            let h = String(name.first!).uppercased()
            headLabel.text = h
        }
        userInfoLabel.text = presenter.getUserInfo()
        
    }
    
    // MARK: - Action
    
    @IBAction func editUserInfo(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JEditUserInfoViewController") as? JEditUserInfoViewController {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.intentData(customer: presenter.getMemberInfo(row: -1), row: 1)
            self.navigationController?.present(viewController, animated: true, completion: {
                
            })
        }
    }
    
    @IBAction func addDevice(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JBluetoothSettingViewController") as? JBluetoothSettingViewController {
            self.parent?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        JUserManager.sharedInstance.logout()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "JRootNavigationController") as? JRootNavigationController {
            UIApplication.shared.delegate?.window??.rootViewController = navigationController
            self.navigationController?.viewControllers = []
        }
    }
}

extension JSideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getTableViewCellNum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JSideMenuTableViewCell
        let tuple = presenter.getTableViewCellData(row: indexPath.row)
        cell.refreshData(name: tuple.0, imageName: tuple.1)
        cell.lineImageView.isHidden = indexPath.row == presenter.getTableViewCellNum() - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 2:
            let viewController = JFAQViewController()
            self.parent?.navigationController?.pushViewController(viewController, animated: true)
        default:
            print("no action")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension JSideMenuViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getMemberCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath)
        if indexPath.row == presenter.getMemberCount() {
            if let imageView = cell.viewWithTag(1) as? UIImageView {
                imageView.image = UIImage(named: "setting_icon_add")
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.textColor = c3
                label.font = t4
                label.text = "Add"
            }
            if let label = cell.viewWithTag(3) as? UILabel {
                label.text = nil
            }
        } else {
            if let imageView = cell.viewWithTag(1) as? UIImageView {
                var r = 0
                if indexPath.row <= 2 {
                    r = indexPath.row + 2
                } else {
                    r = (indexPath.row - 2) % 4 + 1
                }
                imageView.image = UIImage(named: "setting_icon_adavater\(r)")
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.textColor = c3
                label.font = t4
                label.text = presenter.getMemberInfo(row: indexPath.row).name
            }
            if let label = cell.viewWithTag(3) as? UILabel {
                label.textColor = c8
                label.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 20)
                if let name = presenter.getMemberInfo(row: indexPath.row).name {
                    label.text = String(name.first!).uppercased()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var bTem = false
        if indexPath.row == presenter.getMemberCount() {
            bTem = true
        }
        let row = indexPath.row + (bTem ? 1 : 0)
        var r = 0
        if row <= 2 {
            r = row + 2
        } else {
            r = (row - 2) % 4 + 1
        }
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JEditUserInfoViewController") as? JEditUserInfoViewController {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.intentData(customer: bTem ? nil : presenter.getMemberInfo(row: indexPath.row), row: r)
            self.navigationController?.present(viewController, animated: true, completion: {
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 82, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

extension JSideMenuViewController: JSideMenuCallbackDelegate {
    func callbackForRefreshMember() {
        collectionView.reloadData()
    }
    
    func callbackForRefreshUserInfo() {
        userInfoLabel.text = presenter.getUserInfo()
    }
}
