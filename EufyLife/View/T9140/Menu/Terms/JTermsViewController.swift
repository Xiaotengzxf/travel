//
//  JTermsViewController.swift
//  Jouz
//
//  Created by doubll on 2018/4/25.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JTermsViewController: JMenuBaseViewController {
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            webvc.loadUrl(url: url)
        }
        sendScreenView()
    }

    var webvc: SCBaseWebViewController!

    override func makeUI() {
        super.makeUI()
        webvc = SCBaseWebViewController()
        let v = webvc.view!
        self.view.addSubview(v)
        v.snp.makeConstraints({ (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    override func needLeftItem() -> Bool {
        return true
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
