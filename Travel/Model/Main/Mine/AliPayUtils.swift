//
//  AliPayUtils.swift
//  Travel
//
//  Created by ANKER on 2018/12/22.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
public class AliPayUtils: NSObject {
    var context:UIViewController;
    
    public init(context: UIViewController) {
        self.context = context;
    }
    
    public func pay(sign:String){
        let decodedData = sign.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let decodedString:String = (NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue))! as String
        
        AlipaySDK.defaultService().payOrder(decodedString, fromScheme: "com.kilobee.travel.2019", callback: { (resp) in
            print(resp)
        } )
    }
}
