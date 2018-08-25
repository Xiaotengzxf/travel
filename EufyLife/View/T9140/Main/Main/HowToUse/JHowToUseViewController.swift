//
//  JHowToUseViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHowToUseViewController: SCBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    
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
        titleLabel.textColor = c2
        titleLabel.font = t1
        titleLabel.text = "How to use"
        
        let desc = "Place Smart Scale onto a hard and flat surface.\nStep barefoot onto Smart Scale to Analyze your body's composition.\nNote:If Smart Scale has been moved, it will need to be recalibrated."
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 7
        paragraph.paragraphSpacing = 25
        let attributeString = NSAttributedString(string: desc, attributes: [.font: t3, .foregroundColor: c2, .paragraphStyle: paragraph])
        desLabel.attributedText = attributeString
    }
    
    // MARK: - Action
}
