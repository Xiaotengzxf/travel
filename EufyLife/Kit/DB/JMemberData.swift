//
//  JManualCurveData.swift
//  Jouz
//
//  Created by ANKER on 2018/7/7.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import CoreData

class JMemberData: DBContext {
    private let kMember = "MemberData"
    
    override func insert(array: [Any]) -> Bool {
        if let arrayServerData = array as? [[String: Any]] {
            for item in arrayServerData {
                if let serverData = NSEntityDescription.insertNewObject(forEntityName: kMember, into: context) as? MemberData {
                    serverData.id = item["id"] as? String
                    serverData.avatar = item["avatar"] as? String
                    serverData.birthday = item["birthday"] as? Int32 ?? 0
                    serverData.customer_no = item["customer_no"] as? Int32 ?? 0
                    serverData.defaultValue = item["defaultValue"] as? Bool ?? false
                    serverData.height = item["height"] as? Int32 ?? 0
                    serverData.index = item["index"] as? Int32 ?? 0
                    serverData.name = item["name"] as? String
                    serverData.sex = item["sex"] as? String
                    serverData.target_weight = item["target_weight"] as? Int32 ?? 0
                }
            }
            do {
                try context.save()
                return true
            } catch {
                fatalError("save serverdata fail: \(error.localizedDescription)")
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
            fatalError("save serverdata fail: \(error.localizedDescription)")
        }
    }
    
    override func select(condition: Any?) -> [NSManagedObject]? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: kMember)
            if condition != nil {
                let predicate = NSPredicate(format: "id=%@", condition as? String ?? "")
                request.predicate = predicate
            }
            if let result = try context.fetch(request) as? [MemberData] {
                return result
            }
        } catch {
            fatalError("save manual serverdata fail: \(error.localizedDescription)")
        }
        return nil
    }
    
    override func update(array: [Any]) {
        if let arr = array as? [Customer], arr.count > 0 {
            for item in arr {
                if let members = select(condition: item.id) as? [MemberData] {
                    for serverData in members {
                        serverData.avatar = item.avatar
                        serverData.birthday = Int32(item.birthday)
                        serverData.customer_no = Int32(item.customer_no)
                        serverData.defaultValue = item.defaultValue
                        serverData.height = Int32(item.height)
                        serverData.name = item.name
                        serverData.sex = item.sex
                        serverData.target_weight = Int32(item.target_weight)
                        do {
                            try context.save()
                        } catch {
                            fatalError("edit serverdata fail: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
