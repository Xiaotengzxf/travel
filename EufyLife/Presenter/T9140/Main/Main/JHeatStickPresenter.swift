//
//  JHeatStickPresenter.swift
//  Jouz
//
//  Created by ANKER on 2018/4/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHeatStickPresenter: NSObject {
    
    weak var viewDelegate: JHeatStickViewDelegate?
    var modelService: JHeatStickModelServiceDelegate?
    
    init(viewDelegate: JHeatStickViewDelegate) {
        super.init()
        modelService = JHeatStickModelService(presenter: self)
    }
    
    
}

extension JHeatStickPresenter: JHeatStickPresenterDelegate {
    
    func getHeatSticks() -> [String] {
        return modelService?.getHeatSticks() ?? []
    }
    
    func getBrand() -> Int {
        return modelService?.getBrand() ?? 0
    }
    
    func getHeatStick() -> (Int, Int) {
        return modelService?.getHeatStick() ?? (0,0)
    }
    
    func setHeatStick(index: Int) {
        modelService?.setHeatStick(index: index)
    }
    
    func callback(reslut: Bool) {
        viewDelegate?.callback(reslut: reslut)
    }
    
    func getBrands() -> [String] {
        return modelService?.getBrands() ?? []
    }
    
    func setBrand(index: Int) {
        modelService?.setBrand(index: index)
    }
    
}
