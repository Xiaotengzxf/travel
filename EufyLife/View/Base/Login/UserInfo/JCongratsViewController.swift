//
//  JCongratsViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCongratsViewController: JLoginBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewPropertyValue()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
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
    
    // MARK: - Private
    // 设置子视图属性值
    private func setupSubviewPropertyValue() {
        titleLabel.font = t1
        titleLabel.textColor = c2
        titleLabel.text = "Congrats"
        
        iconImageView.image = UIImage(named: "signup_image_congrats")
        
        descLabel.font = t3
        descLabel.textColor = c2
        descLabel.text = "Welcome to EufyLife. For a better experience and accurate data, we need your name, gender, age and height to calculate health information."
        
        okButton.setBackground(size: CGSize(width: screenWidth - 80, height: 54), cornerRadius: 27, addShadow: false)
        okButton.setTitleColor(c8, for: .normal)
        okButton.titleLabel?.font = t3
        okButton.setTitle("OK", for: .normal)
        
    }

    @IBAction func pushToNext(_ sender: Any) {
    }
}
