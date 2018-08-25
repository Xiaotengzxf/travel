//
//  JRenameModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/1/2.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JRenameModelService: NSObject {
    
    weak var presenter: JRenamePresenterDelegate?
    private var temDeviceName = ""
    private var arrName = ["Ash","Aspen","Beech","Birch","Blackthorn","Buckeye","Catalpa","Cedar","Cherry","Chestnut","Coffeetree","Cottonwood","Crabapple","Cypress","Elm","Evodia","Fir","Fringetree","Glorybower","Hemlock","Hickory","Holly","Hoptree","Hornbeam","Juniper","Larch","Lilac","Linden","Magnolia","Maple","Mimosa","Oak","Paperbark","Pawpaw","Pear","Pine","Plum","Rosebud","Rubbertree","Sassafrass","Silverbell","Snowbell","Spruce","Stewartia","Sycamore","Toon","Tupelo","Walnut","Willow","Zelkova"
        ]
    
    init(presenter: JRenamePresenterDelegate) {
        super.init()
        self.presenter = presenter
        registerNotification()
    }
    
    deinit {
        removeNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kRenameNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifiction
    @objc func handleNotification(notification: Notification) {
        
    }
    
}

extension JRenameModelService: JRenameModelServiceDelegate {
    func getDeviceName() -> String {
        return ScaleModel.sharedInstance.localName
    }
    
    func setDeviceName(text: String) {
        temDeviceName = text
        let mData = NSMutableData()
        mData.append(Data(bytes: [UInt8(text.count)]))
        mData.append(text.data(using: String.Encoding.ascii)!)
        //ZFramework.sharedInstance._controlModule.addCmdToQueue(cmd: T9140CMD.setName.rawValue, param: mData as Data)
    }
    
    func getSuggestionName() -> String {
        return arrName[Int(arc4random_uniform(UInt32(arrName.count - 1)))]
    }
}
