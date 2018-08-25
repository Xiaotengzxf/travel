//
//  ZToast.swift
//  Zolo
//
//  Created by ANKER on 2017/8/7.
//  Copyright © 2017年 Anker. All rights reserved.
//

import UIKit

public class ZToast: NSObject {
    
    private var toast : Toast?
    
    public init(text: String?, special: Bool = false) {
        super.init()
        self.toast = Toast(text: text, delay: 0, duration: special ? TimeInterval(Int.max) : Delay.short)
    }
    
    public func show() {
        toast?.show()
    }
    
    public func cancel() {
        toast?.cancel()
    }
}
