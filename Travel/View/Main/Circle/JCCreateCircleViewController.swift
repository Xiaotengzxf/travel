//
//  JCCreateCircleViewController.swift
//  Travel
//
//  Created by ANKER on 2018/10/21.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster
import ALCameraViewController

class JCCreateCircleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let titles = ["圈子头像", "圈子名称", "圈子介绍", "是否需要审核入圈"]
    private var circleName = ""
    private var circleDesc = ""
    private var audit = ""
    private var imageUrl : String?
    
    private var service = JCircleModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
        let circle = Circle()
        circle.name = circleName
        circle.description = circleDesc
        circle.type = audit
        if imageUrl != nil {
            circle.imageUrl = kDEBUGUrl + imageUrl!
        }
        service.createCircle(circle: circle) {
            [weak self] (success, message) in
            if success {
                Toast(text: "创建成功").show()
                self?.navigationController?.popViewController(animated: true)
            } else {
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
    
    @objc private func valueChanged(_ sender: Any) {
        if let mSwitch = sender as? UISwitch {
            audit = mSwitch.isOn ? "Audit" : "notAudit"
        }
    }
    
}

extension JCCreateCircleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JCreateCircleTableViewCell
        cell.iconImageView.isHidden = indexPath.row != 0
        cell.descLabel.isHidden = indexPath.row == 0
        cell.titleLabel.text = titles[indexPath.row]
        if indexPath.row == 1 {
            cell.descLabel.text = circleName
        } else if indexPath.row == 2 {
            cell.descLabel.text = circleDesc
        } else {
            cell.iconImageView.image = UIImage(named: "icon_2")
        }
        if indexPath.row == 3 {
            let mSwitch: UISwitch = UISwitch()
            mSwitch.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
            cell.accessoryView = mSwitch
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let cropping = CroppingParameters()
            let cameraViewController = CameraViewController(croppingParameters: cropping, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: false){ [weak self] image, asset in
                // Do something with your image here.
                let cell = self?.tableView.cellForRow(at: indexPath) as! JCreateCircleTableViewCell
                if image != nil {
                    JHUD.show(at: self!.view)
                    self?.service.uploadHeaderIcon(imageData: UIImageJPEGRepresentation(image!, 0.1)!){
                        (result, url) in
                        DispatchQueue.main.async {
                            [weak self] in
                            JHUD.hide(for: self!.view)
                            if result {
                                cell.iconImageView.image = image
                                if let jsonStr = url, jsonStr.count > 0 {
                                    if let data = jsonStr.data(using: .utf8) {
                                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                                            self?.imageUrl = json?["data"] as? String
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        case 1, 2:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "JInputViewController") as? JInputViewController {
                vc.flag = indexPath.row
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            print(indexPath.row)
        }
    }
}

extension JCCreateCircleViewController: JInputViewControllerDelegate {
    func callbackWithText(flag: Int, value: String) {
        if flag == 1 {
            circleName = value
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! JCreateCircleTableViewCell
            cell.descLabel.text = circleName
        } else if flag == 2 {
            circleDesc = value
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! JCreateCircleTableViewCell
            cell.descLabel.text = circleDesc
        }
        
    }
}
