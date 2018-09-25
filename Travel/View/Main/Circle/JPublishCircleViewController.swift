//
//  JPublishCircleViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JPublishCircleViewController: UIViewController {

    @IBOutlet weak var circleDescTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleDescTextView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
            circleDescTextView.layer.borderWidth = 0.5
            circleDescTextView.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "999999")
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
