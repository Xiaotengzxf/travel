//
//  ZColorManager.swift
//  Jouz
//
//  Created by ANKER on 2017/12/21.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class ZColorManager {
    
    static let sharedInstance = ZColorManager()
    private let dictColor: [String: String]?
    
    private init() {
        let filePath = Bundle.main.path(forResource: "CommonValue", ofType: "plist")
        assert(filePath != nil, "CommonValue.plist file is not exist")
        let root = NSDictionary(contentsOfFile: filePath!)
        dictColor = root?["Color"] as? [String: String]
    }
    
    func getColor(color: EColor) -> UIColor {
        return colorWithHexString(hex: dictColor?[color.rawValue] ?? "FFFFFF")
    }
    
    func colorWithHexString (hex: String) -> UIColor {
        var cString = hex
        if (hex.hasPrefix("#")) {
            cString = (hex as NSString).substring(from: 1)
        }
        if (cString.count != 6) {
            return UIColor.gray
        }
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}

enum EColor : String {
    case c1 = "c1"
    case c2 = "c2"
    case c3 = "c3"
    case c4 = "c4"
    case c6 = "c6"
    case c7 = "c7"
    case c8 = "c8"
    case c9 = "c9"
    case c_button_normal_left = "c_button_normal_left"
    case c_button_normal_right = "c_button_normal_right"
    case c_button_press_left = "c_button_press_left"
    case c_button_press_right = "c_button_press_right"
    case c_background_top = "c_background_top"
    case c_background_bottom = "c_background_bottom"
    case c_button_shadow = "c_button_shadow"
}
