//
//  SCBaseViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/1/15.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class SCBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "F5F5F5")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
