//
//  JFAQModelService.swift
//  Jouz
//
//  Created by doubll on 2018/6/5.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

class JFAQModelService: NSObject {
    weak var presenter: JFAQPresenterDelegate?
    init(presenter: JFAQPresenterDelegate) {
        super.init()
        self.presenter = presenter
    }
    
    private func getFAQDataPath() -> String? {
        if let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            return "\(filePath)/faq.data"
        }
        return nil
    }
    
    private func decodeFAQData() -> [FAQObj]? {
        if let url = getFAQDataPath() {
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: url) as? [FAQObj]{
                return array
            }
        }
        return nil
    }
    
    private func encodeFAQData(array : [FAQObj]) {
        if let filePath = getFAQDataPath() {
            NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
        }
    }
}

extension JFAQModelService: JFAQModelServiceDelegate {
    
    func requestFAQ(completion: (([Any]?)->Void)?) -> [FAQObj]? {
        let model = JFAQRequestModel(productCode: "eufy T9140")
        ZNetwork().request(strUrl: model.url(), strMethod: "GET", parameters: nil, headers: model.toHeader()) {[weak self] (msg, error) in
            if let response = msg?.replacingOccurrences(of: "\n", with: "") {
                let data = response.data(using: .utf8)
                let model = try? JSONDecoder().decode(JFAQResponseModel.self, from: data!)
                var result = [FAQObj]()
                if let model = model {
                    for obj in model.data ?? [] {
                        let o = FAQObj(hidden: true, question: obj.question ?? "", answer: obj.answer ?? "")
                        result.append(o)
                    }
                }
                if result.count > 0 {
                    self?.encodeFAQData(array: result)
                }
                completion?(result)
            } else {
               completion?(nil)
            }
        }
        return decodeFAQData()
    }
}

