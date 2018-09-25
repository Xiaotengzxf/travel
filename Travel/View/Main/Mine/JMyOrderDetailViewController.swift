//
//  JMyOrderDetailViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyOrderDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var reserverLabel: UILabel!
    @IBOutlet weak var orderInfoView: UIView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var orderPayLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var scrollViewBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderInfoViewBottomLConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<3 {
            let userInfoView = Bundle.main.loadNibNamed("JUserInfoView", owner: nil, options: nil)!.first as! JUserInfoView
            userInfoView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(userInfoView)
            
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(11)-[view]-(11)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : userInfoView]))
            
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[fView]-(value)-[view(203)]", options: .directionLeadingToTrailing, metrics: ["value" : CGFloat((i + 1) * 11 + i * 203)], views: ["view" : userInfoView, "fView": orderInfoView]))
        }
        
        orderInfoViewBottomLConstraint.constant = 11 + (11 + 203) * 3
        payButton.isHidden = true
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

    @IBAction func payOrCancelOrder(_ sender: Any) {
    }
}
