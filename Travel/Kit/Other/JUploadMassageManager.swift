//
//  JUploadMassageManager.swift
//  Travel
//
//  Created by ANKER on 2018/11/17.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit

class JUploadMassageManager: NSObject {
    
    static let sharedInstance = JUploadMassageManager()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: Notification.Name("JUploadMassageManager"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func testLog() {
        print("JUploadMassageManager testLog")
    }
    
    @objc private func handleNotification(notification: Notification) {
        if let object = notification.object as? Int {
            if object == 1 {
                if let userinfo = notification.userInfo as? [String : Any] {
                    let id = userinfo["id"] as? String ?? ""
                    let content = userinfo["content"] as? String ?? ""
                    let isToUser = userinfo["isToUser"] as? Bool ?? false
                    let request = JUploadMassageRequestModel(id: id, content: content, isToUser: isToUser)
                    let network = ZNetwork()
                    network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: request.toHeader()) { (response, error) in
                    }
                }
            }
        }
    }
    
    
}

class JUploadMassageRequestModel: JBaseRequestModel {
    
    private var content: String = ""
    private var id: String = ""
    private var isToUser = false
    
    init(id: String, content: String, isToUser: Bool) {
        super.init()
        self.content = content
        self.id = id
        self.isToUser = isToUser
    }
    
    override func url() -> String {
        return super.url() + "api/message"
    }
    
    override func toBody() -> [String : Any] {
        if isToUser {
            return ["toUserId": id, "content": content, "type": "0"]
        } else {
            return ["circleId": id, "content": content, "type": "1"]
        }
    }
}
