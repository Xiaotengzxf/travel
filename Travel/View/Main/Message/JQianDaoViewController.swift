//
//  JQianDaoViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/24.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JQianDaoViewController: UIViewController {

    @IBOutlet weak var locationInfoTextField: UITextField!
    @IBOutlet weak var gatherButton: UIButton!
    @IBOutlet weak var constantButton: UIButton!
    @IBOutlet weak var addressButtonA: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationInfoTextField.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        locationInfoTextField.layer.borderWidth = 0.5
        gatherButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        gatherButton.layer.borderWidth = 0.5
        constantButton.layer.cornerRadius = 17
        addressButtonA.layer.cornerRadius = 17
        constantButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        constantButton.layer.borderWidth = 0.5
        addressButtonA.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        addressButtonA.layer.borderWidth = 0.5
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发起", style: .plain, target: self, action: #selector(start))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func start() {
        
    }

    @IBAction func gather(_ sender: Any) {
        
    }
}
