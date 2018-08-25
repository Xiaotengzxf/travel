//
//  JDetailViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/22.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var bmiView: UIView!
    @IBOutlet weak var fatView: UIView!
    @IBOutlet weak var connectLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var goalValueLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func editGoal(_ sender: Any) {
    }
}
