//
//  JDevice.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/22.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import CoreData

class JDeviceData: DBContext {
    let kDevice = "DeviceData"
    
    override func insert(array: [Any]) -> Bool {
        if let arrayServerData = array as? [[String: Any]] {
            for item in arrayServerData {
                if let serverData = NSEntityDescription.insertNewObject(forEntityName: kDevice, into: context) as? DeviceData {
                    serverData.mac = item["mac"] as? String
                    serverData.name = item["name"] as? String
                    serverData.sn = item["sn"] as? String
                    serverData.softwareVersion = item["softwareVersion"] as? String
                    serverData.userId = item["userId"] as? String
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
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: kDevice)
            if condition != nil {
                let predicate = NSPredicate(format: "userId=%@", condition as? String ?? "")
                request.predicate = predicate
            }
            if let result = try context.fetch(request) as? [DeviceData] {
                return result
            }
        } catch {
            fatalError("save manual serverdata fail: \(error.localizedDescription)")
        }
        return nil
    }
}
