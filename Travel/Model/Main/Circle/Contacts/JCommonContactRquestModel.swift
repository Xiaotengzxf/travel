//
//  JCommonContactRquestModel.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JCommonContactRquestModel: JBaseRequestModel {
    
    private var type: String?
    
    init(type: String?) {
        super.init()
        self.type = type
    }
    
    override func url() -> String {
        if type == nil {
            return super.url() + "api/contact"
        } else {
            let url = "api/contact?criteria={\"type\":\"\(type!)\"}"
            let urlB = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlC = urlB.replacingOccurrences(of: ":", with: "%3A")
            return super.url() + urlC
        }
    }
    
    override func toHeader() -> [String : String] {
        var header = super.toHeader()
        header["Authorization"] = JUserManager.sharedInstance.user?.token ?? ""
        return header
    }
}
