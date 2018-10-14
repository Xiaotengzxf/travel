//
//  JInputViewController.swift
//  Travel
//
//  Created by ANKER on 2018/11/3.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JInputViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    public weak var delegate: JInputViewControllerDelegate?
    public var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
        delegate?.callbackWithText(flag: flag, value: textView.text)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol JInputViewControllerDelegate: NSObjectProtocol {
    func callbackWithText(flag: Int, value: String)
}
