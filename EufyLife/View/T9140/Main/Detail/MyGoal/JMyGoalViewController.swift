//
//  JMyGoalViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/25.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyGoalViewController: SCBaseViewController {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var healthyLabel: UILabel!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var unit2Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViewPropertyValue()
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
        
    }

    // MARK: - Action
    
    @IBAction func reduceGoal(_ sender: Any) {
    }
    @IBAction func increseGoal(_ sender: Any) {
    }
}
