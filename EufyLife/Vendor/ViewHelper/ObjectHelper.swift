//
//  ObjectHelper.swift
//  Jouz
//
//  Created by doubll on 2018/5/28.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension NSObject {
    func merge<aT: Codable, bT: Codable>(oldModel: aT, into newModel: bT) -> bT {
        let oldData = try! JSONEncoder().encode(oldModel)
        let oldDic = try! JSONSerialization.jsonObject(with: oldData, options: .mutableContainers)

        let newData = try! JSONEncoder().encode(newModel)
        let newDic = try! JSONSerialization.jsonObject(with: newData, options: .mutableContainers)
        let resultDic = Dictionary<String, Any>.update(from: oldDic as! Dictionary<String, Any>, to: newDic as! Dictionary<String, Any>)
        //        print(resultDic)

        let resultData = try! JSONSerialization.data(withJSONObject: resultDic, options: [])
        let newModel = try! JSONDecoder().decode(type(of: newModel), from: resultData)

        //        print(newModel)
        return newModel
    }
}


extension NSObject {
    func logInfo(_ info: String = "", file:String = #file, sel: Selector = #function, line: UInt = #line) {
        #if DEBUG
            let logInfo = "---> info: \(info), file: \(file), function: \(sel), line: \(line)"
            debugPrint(logInfo)
        #endif
    }
}


