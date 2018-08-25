//
//  JHeatStickModelService.swift
//  Jouz
//
//  Created by ANKER on 2018/4/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHeatStickModelService: NSObject {
    
    private weak var presenter: JHeatStickPresenterDelegate?
    private var model: JHeatSticksResponseModel?
    private var brand = 0 // 香烟品牌
    private var heatStick = (0, 0) // 口味
    
    init(presenter: JHeatStickPresenterDelegate) {
        super.init()
        self.presenter = presenter
        registerNotification()
        decodeCurve()
    }
    
    deinit {
        removeNotification()
    }
    
    private func registerNotification() {
        //NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kHeatStickNotification, object: nil)
    }
    
    private func removeNotification() {
        //NotificationCenter.default.removeObserver(self)
    }
    
    // 处理通知
    @objc private func handleNotification(notification: Notification) {
//        if let object = notification.object as? Int {
//            switch object {
//            
//            default:
//                fatalError()
//            }
//        }
    }
    
    // MARK: - Private
    
    private func getHeatStickData() -> JHeatSticksResponseModel? {
        if model == nil {
            if let url = getHeatSticksDataPath() {
                var data : Data? = nil
                if let d = try? Data(contentsOf: url) {
                    data = d
                } else {
                    let filePath = Bundle.main.path(forResource: "heatStick", ofType: "data")
                    data = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
                }
                model =  try? JSONDecoder().decode(JHeatSticksResponseModel.self, from: data!)
            }
        }
        return model
    }
    
    private func getHeatSticksDataPath() -> URL? {
        if let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            return URL(fileURLWithPath: "\(filePath)/heatStick.data")
        }
        return nil
    }
    
    private func decodeCurve() {
        
    }
}

extension JHeatStickModelService: JHeatStickModelServiceDelegate {
    
    func getHeatSticks() -> [String] {
        var key = "ja-JP"
        let language = SCLanguageManager.sharedInstance.currentLanguage()
        if language != "ja" {
            key = "en-US"
        }
        let heatSticks = getHeatStickData()?.side_brands?[brand]
        return heatSticks?.heatsticks?.map{$0.lang?[key] ?? ($0.name ?? "")} ?? []
    }
    
    func getBrands() -> [String] {
        var key = "ja-JP"
        let language = SCLanguageManager.sharedInstance.currentLanguage()
        if language != "ja" {
            key = "en-US"
        }
        return getHeatStickData()?.side_brands?.map{$0.lang?[key] ?? ($0.name ?? "")} ?? []
    }
    
    func getBrand() -> Int {
        return brand
    }
    
    func getHeatStick() -> (Int, Int) {
        return heatStick
    }
    
    func setHeatStick(index: Int) {
        let heatSticks = getHeatStickData()?.side_brands?[brand]
        heatStick = (brand, index)
        let stick = heatSticks?.heatsticks?[heatStick.1]
        let flavor_id = stick?.flavor_id ?? ""
        let userinfo = ["flavor_id" : flavor_id, "heatStick_id": stick?.uuid ?? "", "name": stick?.name ?? "", "brand_id": heatSticks?.uuid ?? ""]
        NotificationCenter.default.post(name: kMainNotification, object: Int.max, userInfo: userinfo)
    }
    
    func setBrand(index: Int) {
        brand = index
    }
    
}
