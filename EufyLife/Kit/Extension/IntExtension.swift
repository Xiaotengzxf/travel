//
//  IntExtension.swift
//  Jouz
//
//  Created by ANKER on 2018/1/19.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension Int {
    func toSize() -> String {
        if self == 0 {
            return ""
        } else if self < 1024 {
            return "\(NSString(format: "%.2fK", CGFloat(self) / CGFloat(1024)))"
        } else {
            return "\(NSString(format: "%.2fM", CGFloat(self) / CGFloat(1024 * 1024)))"
        }
    }
}
