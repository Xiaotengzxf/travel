//
//  JScaleDataList.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/22.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import CoreData

class JScaleData: DBContext {
    private let kScaleData = "ScaleData"
    
    override func insert(array: [Any]) -> Bool {
        if let arrayServerData = array as? [[String: Any]] {
            for item in arrayServerData {
                if let serverData = NSEntityDescription.insertNewObject(forEntityName: kScaleData, into: context) as? ScaleData {
                    serverData.fitbitStatus = item["fitbitStatus"] as? Bool ?? false
                    serverData.healthStatus = item["healthStatus"] as? Bool ?? false
                    serverData.serverStatus = item["serverStatus"] as? Bool ?? false
                    serverData.userId = item["userId"] as? String
                    serverData.memberId = item["memberId"] as? String
                    serverData.timeStamp = item["timeStamp"] as? Int32 ?? 0
                    serverData.weight = item["weight"] as? Float ?? 0
                }
            }
            do {
                try context.save()
                return true
            } catch {
                fatalError("save manual serverdata fail: \(error.localizedDescription)")
            }
        }
        return false
    }
    
    override func delete(array: [NSManagedObject]) {
        for obj in array {
            context.delete(obj)
        }
        do {
            try context.save()
        } catch {
            fatalError("save manual serverdata fail: \(error.localizedDescription)")
        }
    }
    
    override func select(condition: Any?) -> [NSManagedObject]? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: kScaleData)
            if let result = try context.fetch(request) as? [ScaleData] {
                return result
            }
        } catch {
            fatalError("save manual serverdata fail: \(error.localizedDescription)")
        }
        return nil
    }
}
