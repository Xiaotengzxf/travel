//
//  Extenstions.swift
//  Zolo
//
//  Created by ANKER on 2017/7/28.
//  Copyright © 2017年 Anker. All rights reserved.
//

import UIKit

extension String {
    
    func md5() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        return String(format: hash as String)
    }
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }
    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func validatePhone () -> Bool {
        let pattern = "^1[0-9]{10}$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    
}

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
    
    func toDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        if str.count >= 19 {
            let start = str.index(str.startIndex, offsetBy: 0)
            let end = str.index(str.startIndex, offsetBy: 10)
            return String(str[start...end])
        }
        return ""
    }
    
    func toDateB() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        if str.count >= 19 {
            let start = str.index(str.startIndex, offsetBy: 0)
            let end = str.index(str.startIndex, offsetBy: 15)
            return String(str[start...end])
        }
        return ""
    }
    
    func toDay() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        if str.count >= 19 {
            let start = str.index(str.startIndex, offsetBy: 5)
            let end = str.index(str.startIndex, offsetBy: 10)
            return String(str[start...end])
        }
        return ""
    }
    
    func toTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        if str.count >= 19 {
            let start = str.index(str.startIndex, offsetBy: 11)
            let end = str.index(str.startIndex, offsetBy: 15)
            return String(str[start...end])
        }
        return ""
    }
    
    func toDateAndTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        if str.count >= 19 {
            let start = str.index(str.startIndex, offsetBy: 5)
            let end = str.index(str.startIndex, offsetBy: 15)
            return String(str[start...end])
        }
        return ""
    }
    
    func weekday() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let weekdays:NSArray = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: date)
        var index = theComponents.weekday! - 1
        if index < 0 {
            index = 0
        } else if index > 6 {
            index = 6
        }
        let week = weekdays[index]
        return week as! String
    }
    
    func dayAndweekday() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let weekdays:NSArray = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday, .month, .day], from: date)
        var index = theComponents.weekday! - 1
        if index < 0 {
            index = 0
        } else if index > 6 {
            index = 6
        }
        let week = weekdays[index]
        let month = theComponents.month!
        let day = theComponents.day!
        return "\(month)/\(day) \(week)"
    }
}


