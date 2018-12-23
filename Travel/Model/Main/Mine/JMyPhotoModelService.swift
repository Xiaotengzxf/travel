//
//  JMyPhotoModelService.swift
//  Travel
//
//  Created by ANKER on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyPhotoModelService: NSObject {
    func getMyPhoto(callback: @escaping (([String], [[MyPhotoModel]])?, String?)->()) {
        let request = JMyPhotoRequestModel()
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "GET", parameters: nil, headers: request.toHeader()) {
            [weak self] (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JMyPhotoResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(self?.sortMyPhoto(array: model?.data), nil)
                    } else {
                        callback(nil, model?.errMsg)
                    }
                } else {
                    callback(nil, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(nil, "网络异常，请检查网络")
                    } else {
                        callback(nil, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func uploadMyPhoto(url: String, callback: @escaping (Bool, String?)->()) {
        let request = JPhotoRequestModel(urlStr: url)
        let network = ZNetwork()
        network.request(strUrl: request.url(), strMethod: "POST", parameters: request.toBody(), headers: request.toHeader()) {
             (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JBaseResponseModel.self, from: data)
                    if model?.errCode == 0 {
                        callback(true, nil)
                    } else {
                        callback(false, model?.errMsg)
                    }
                } else {
                    callback(false, "服务器异常，请稍后重试")
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        callback(false, "网络异常，请检查网络")
                    } else {
                        callback(false, "服务器异常，请稍后重试")
                    }
                }
            }
        }
    }
    
    func uploadHeaderIcon(imageData: Data, callback: @escaping (Bool, String?) -> ()) {
        let request = JIconUploadRequestModel()
        let network = ZNetwork()
        network.upload(data: imageData, url: request.url(), queue: DispatchQueue.global()) {
            (result, url) in
            callback(result, url)
        }
    }
    
    private func sortMyPhoto(array: [MyPhotoModel]?) -> ([String], [[MyPhotoModel]]) {
        if let arr = array, arr.count > 0 {
            var key : [String] = []
            var list : [String : [MyPhotoModel]] = [:]
            for item in arr {
                if let timestamp = item.createTime {
                    let date = Int(timestamp / 1000).toDate()
                    let array = date.components(separatedBy: "-")
                    let day = "\(array[0])年\(array[1])月\(array[2])日"
                    if !key.contains(day) {
                        key.append(day)
                    }
                    if var value = list[day], value.count > 0 {
                        value.append(item)
                        let v = value.sorted { (item1, item2) -> Bool in
                            return item1.createTime ?? 0 > item2.createTime ?? 0
                        }
                        list[day] = v
                    } else {
                        var value : [MyPhotoModel] = []
                        value.append(item)
                        list[day] = value
                    }
                }
            }
            let k = key.sorted {[weak self] (item1, item2) -> Bool in
                return self?.compare(k1: item1, k2: item2) ?? false
            }
            var last : [[MyPhotoModel]] = []
            for i in 0..<key.count {
                let v = list[k[i]] ?? []
                last.append(v)
            }
            return (k, last)
        }
        return ([], [])
    }
    
    private func compare(k1: String, k2: String) -> Bool {
        let v1 = k1.components(separatedBy: "年")
        let year1 = Int(v1[0]) ?? 0
        let v11 = v1[1].components(separatedBy: "月")
        let month1 = Int(v11[0]) ?? 0
        let day1 = Int(v11[1].replacingOccurrences(of: "日", with: "")) ?? 0
        let v2 = k2.components(separatedBy: "年")
        let year2 = Int(v2[0]) ?? 0
        let v21 = v2[1].components(separatedBy: "月")
        let month2 = Int(v21[0]) ?? 0
        let day2 = Int(v21[1].replacingOccurrences(of: "日", with: "")) ?? 0
        if year1 > year2 {
            return true
        } else if year1 == year2 {
            if month1 > month2 {
                return true
            } else if month1 == month2 {
                return day1 > day2
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
