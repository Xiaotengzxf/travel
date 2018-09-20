//
//  JMyOrderViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyOrderViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var lineWidthLConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineLeadingLConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "666666")], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor: ZColorManager.sharedInstance.colorWithHexString(hex: "000000")], for: .selected)
        lineWidthLConstraint.constant = 34
        lineLeadingLConstraint.constant = (screenWidth / 5 - 34) / 2
        
        tableView.rowHeight = UITableViewAutomaticDimension
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

    @IBAction func valueChanged(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        var width : CGFloat = 0
        if index == 0 || index == 3 {
            width = 34
        } else {
            width = 49
        }
        lineWidthLConstraint.constant = width
        lineLeadingLConstraint.constant = CGFloat(index) * screenWidth / 5 + (screenWidth / 5 - width) / 2
    }
}

extension JMyOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMyOrderTableViewCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}
