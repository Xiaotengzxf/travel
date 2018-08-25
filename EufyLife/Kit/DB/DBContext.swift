//
//  DBContext.swift
//  Jouz
//
//  Created by ANKER on 2018/2/5.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import CoreData

class DBContext: NSObject {

    var context: NSManagedObjectContext!
    
    override init() {
        super.init()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
    }
    
    internal func insert(array: [Any]) -> Bool {
        return false
    }
    
    internal func update(array: [Any]) {
        
    }
    
    internal func delete(array: [NSManagedObject]) {
        
    }
    
    internal func select(condition: Any?) -> [NSManagedObject]? {
        return nil
    }
    
}
