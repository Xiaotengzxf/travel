//
//  SCLocalizedViewController.swift
//  Jouz
//
//  Created by SeanGao on 2018/1/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Localize_Swift

class SCLocalizedViewController: SCBaseViewController {

    lazy var leftItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "common_icon_back"), style: .plain, target: self, action: #selector(leftEvent(_ :)))
    }()


    @objc func leftEvent(_ item: UIBarButtonItem) {
        if let closure = leftClosure {
            closure()
        } else {
            if self.navigationController?.viewControllers.count ?? 0 > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }
        }
    }

    var leftClosure: (()->Void)?

    func needLeftItem() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        if needLeftItem() {
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func reloadText() {
        
    }
    
}
