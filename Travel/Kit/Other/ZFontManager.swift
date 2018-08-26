//
//  ZFontManager.swift
//  Jouz
//
//  Created by ANKER on 2017/12/21.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class ZFontManager {
    
    static let sharedInstance = ZFontManager()
    private let dictFont: [String: Int]?
    
    private init() {
        let filePath = Bundle.main.path(forResource: "CommonValue", ofType: "plist")
        let root = NSDictionary(contentsOfFile: filePath!)
        dictFont = root?["Font"] as? [String: Int]
    }
    
    func getFont(font: Font, bBold: Bool = false) ->  UIFont {
        let size = CGFloat(dictFont?[font.rawValue] ?? 16) * scale
        if font == .t1 {
            return UIFont(name: FontType.black.rawValue, size:  size)!
        } else if font == .t2 {
            return UIFont(name: FontType.bold.rawValue, size: size)!
        } else {
            return UIFont(name: FontType.medium.rawValue, size:  size)!
        }
    }
    
    func getOtherFont(font: Font, bBold: Bool = false) ->  UIFont {
        let size = CGFloat(dictFont?[font.rawValue] ?? 16) * scale
        return UIFont(name: FontType.regular.rawValue, size:  size)!
    }
    
    func getFont(type: FontType, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
    
}

enum Font : String {
    case t1 = "t1"
    case t2 = "t2"
    case t3 = "t3"
    case t4 = "t4"
    case t5 = "t5"
}

enum FontType : String {
    case black = "BoosterNextFY-Black"
    case bold = "BoosterNextFY-Bold"
    case medium = "BoosterNextFY-Medium"
    case regular = "BoosterNextFY-Regular"
}
