//
//  AreaFactory.swift
//  pickCellTest
//
//  Created by JarlRyan on 15/10/23.
//  Copyright © 2015年 JarlRyan. All rights reserved.
//

import Foundation

class AreaFactory: NSObject {
    
    class func getAreaArray()->NSArray{
        let path : String = Bundle.main.path(forResource: "area", ofType: "plist")!
        let resourceArray = NSArray(contentsOfFile: path)
        let modelArray : NSMutableArray = NSMutableArray()
        resourceArray?.enumerateObjects({
            (item,idx,stop) -> Void in
            
            let model : AreaModel = AreaModel(dictionary: item as! NSDictionary)
            modelArray.add(model)
        })
        
        return modelArray
    }

}
