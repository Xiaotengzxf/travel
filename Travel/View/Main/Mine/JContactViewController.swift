//
//  JContactViewController.swift
//  Travel
//
//  Created by ANKER on 2018/8/26.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JContactViewController: SCBaseViewController {

    @IBOutlet weak var contactButton: UIButton!
    private let service = JContactModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.contact {[weak self] (result, message) in
            if result != nil {
                self?.contactButton.setTitle("联系电话：\(result!)", for: .normal)
            }
            if message != nil {
                Toast(text: message!).show()
            }
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

    @IBAction func contact(_ sender: Any) {
    }
}
