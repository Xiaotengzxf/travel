//
//  ZHUD.swift
//  Zolo
//
//  Created by ANKER on 2017/8/7.
//  Copyright © 2017年 Anker. All rights reserved.
//

import UIKit

class ZHUD: NSObject {
    
    static let sharedInstance = ZHUD()
    var timeStamp : Int = 0
    
    func showHUD(bTransparency: Bool = false) {
        JHUD.show(at: nil, bTransparency: bTransparency, bWait: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15, execute: {
            [weak self] in
            self?.hideHUD(view: nil)
        })
    }
    
    func hideHUD(view: UIView? = nil) {
        JHUD.hide(for: nil)
    }
    
    func showHUD(view: UIView, bTransparency: Bool = false, bWait: Bool = false) {
        JHUD.show(at: view, bTransparency: bTransparency, bWait: bWait)
    }
    
    func hideHUD(view: UIView, animated: Bool, completed: ((Bool) -> Void)?) {
        JHUD.hide(for: view)
    }
    
}

extension UIViewController {
    
    func showHUD(bTransparency: Bool = false, bWait: Bool = false) {
        ZHUD.sharedInstance.showHUD(view: self.view, bTransparency: bTransparency, bWait: bWait)
    }
    
    func hideHUD() {
        ZHUD.sharedInstance.hideHUD(view: self.view, animated: true) { (completed) in
            
        }
    }
    
}
