//
//  JContext.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit


class JContext: NSObject {
    
    public static let instanceShared = JContext()
    
    public func convertUnitData(weight: Float, wUnit: WeightUnit) -> String {
        switch wUnit {
        case .kg:
            return String(format: "%.1f", arguments: [weight])
        case .lb:
            return String(format: "%.1f", arguments: [weight * 2.2046])
        default:
            let lbs = weight * 2.2046
            var m = Int(floorf(lbs / 14))
            var n = Int(roundf(lbs.truncatingRemainder(dividingBy: 14)))
            if n == 14 {
                m += 1
                n = 0
            }
            return n < 10 ? "\(m):0" : "\(m):\(n)"
        }
    }
    
    public func convertBirthdayToAge(birthday: Int) -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(birthday))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let d1 = dateFormatter.string(from: Date())
        let d2 = dateFormatter.string(from: date)
        let year1 = Int(d1.components(separatedBy: "-").first ?? "0") ?? 0
        let year2 = Int(d2.components(separatedBy: "-").first ?? "0") ?? 0
        return year1 - year2
    }
    
    public func convertAgeToBirthday(age: Int) -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let d = dateFormatter.string(from: date)
        let y = d.components(separatedBy: "-").first
        let year = Int(y ?? "0") ?? 0
        let dateString = "\(year - age)-01-01 00:00:00"
        let dateNew = dateFormatter.date(from: dateString)
        let time = dateNew?.timeIntervalSince1970 ?? 0
        return Int(time)
    }
    
    public func convertFTorCM(value: String) -> String {
        if value.contains("'") {
            let array = value.components(separatedBy: "'")
            let FT = Double(Int(array[0]) ?? 0)
            let IN = Double(Int(array[1].replacingOccurrences(of: "\"", with: "")) ?? 0)
            let cm = (FT + IN / 12) / 0.032808399
            return "\(Int(round(cm)))"
        } else {
            let cm = Double(value) ?? 0
            let FT = Int(cm * 0.032808399)
            let IN = Int(round(((cm * 0.032808399 - Double(FT)) * 12)))
            return "\(FT)'\(IN)\""
        }
    }
    
    public func initialAge() -> [String] {
        var arrayAge : [String] = []
        for i in 0...108 {
            arrayAge.append("\(i + 13)")
        }
        return arrayAge
    }
    
    public func initailHeight() -> ([[String]], [[String]]) {
        var arrayHeightFL: [[String]] = []
        var arrayHeightCM: [[String]] = []
        
        var height: [String] = []
        for i in 0...5 {
            height.append("\(i + 3)'")
        }
        arrayHeightFL.append(height)
        height.removeAll()
        for i in 0...10 {
            height.append("\(i + 1)\"")
        }
        arrayHeightFL.append(height)
        height.removeAll()
        for i in 0...140 {
            height.append("\(i + 100)")
        }
        arrayHeightCM.append(height)
        height.removeAll()
        height += ["ft", "cm"]
        arrayHeightFL.append(height)
        arrayHeightCM.append(height)
        return (arrayHeightFL, arrayHeightCM)
    }
}
