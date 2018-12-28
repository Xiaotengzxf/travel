//
//  JChatViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/23.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class JChatViewController: EaseMessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showRefreshHeader = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func moreViewCommunicationAction(_ moreView: EaseChatBarMoreView!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "JQianDaoViewController") as? JQianDaoViewController
        viewController?.title = title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

}
