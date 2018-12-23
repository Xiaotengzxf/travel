//
//  ZNetwork.swift
//  Zolo
//
//  Created by ANKER on 2017/8/7.
//  Copyright © 2017年 Anker. All rights reserved.
//

import UIKit
import Alamofire

class ZNetwork: NSObject {
    
    enum Encoding: Int {
        case defaultEncoding
        case httpBody
        case jsonBody
        
        func toUrlEncoding() -> ParameterEncoding {
            switch self {
            case .defaultEncoding:
                return URLEncoding.default
            case .httpBody:
                return URLEncoding.httpBody
            case .jsonBody:
                return JSONEncoding.default
            }
        }
    }
    
    enum QueueType : Int {
        case main
        case background
        case custom
        
        func toQueue() -> DispatchQueue {
            switch self {
            case .main:
                return DispatchQueue.main
            case .background:
                return DispatchQueue.global()
            case .custom:
                return DispatchQueue(label: Bundle.main.bundleIdentifier ?? "Jouz")
            }
        }
    }
    private var oRequest : Request?
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func request(strUrl: String, strMethod: String, parameters: [String : Any
        ]?, headers: [String : String]?, queue: QueueType = .main, callback: @escaping (String?, Error?)->()) {
        self.request(strUrl: strUrl, strMethod: strMethod, parameters: parameters, encoding: Encoding.jsonBody.toUrlEncoding(), headers: headers, queue: queue, callback: callback)
    }
    
    func request(strUrl: String, strMethod: String, parameters: [String : Any
        ]?,encoding: ParameterEncoding, headers: [String : String]?, queue: QueueType = .main, callback: @escaping (String?, Error?)->()) {
        log.info("[\(strUrl)] [\(String(describing: headers))] [\(String(describing: parameters))]")

        oRequest = ZNetwork.sharedSessionManager.request(strUrl, method: HTTPMethod(rawValue: strMethod) ?? .get, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: { (response) in
            if let data = response.result.value {
                let value = String(data: data, encoding: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    log.info("[\(strUrl)] [\(json)]")
                } else {
                    log.info("[\(strUrl)] [\(value)]")
                }
                
                callback(value, response.error)
            } else {
                callback(nil, response.error)
            }
        })
    }
    
    func upload(data: Data, url: URLConvertible, queue: DispatchQueue?, callback: @escaping (Bool, String?) -> ()) {
        Alamofire.upload(multipartFormData: { (mData) in
            mData.append(data, withName: "file", fileName: String(Date().timeIntervalSince1970) + ".jpeg", mimeType: "image/jpeg")
            mData.append("article".data(using: .utf8)!, withName: "type")
            //mData.append("travel".data(using: .utf8)!, withName: "AppId")
        }, to: url, headers: ["AppId" : "travel"], encodingCompletion: { (result) in
            switch result {
            case .success(let request, _, _):
                request.responseData(queue: queue) { (response) in
                    if response.error != nil {
                        print("上传图片失败：\(response.error?.localizedDescription ?? "")")
                        callback(false, nil)
                    } else {
                        if let data = response.result.value {
                            if let value = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                                if let d = value?["data"] as? String {
                                    callback(true, d)
                                } else {
                                    callback(false, "图片上传失败")
                                }
                            } else {
                                callback(false, "图片上传失败")
                            }
                        } else {
                            callback(false, "图片上传失败")
                        }
                    }
                }
            case .failure(let error):
                print("上传图片失败：\(error)")
                callback(false, "图片上传失败")
            }
        })
    }
    
    func download(strUrl: String, callback: @escaping (CGFloat?, Error?) -> ()) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(NSString(string: strUrl).lastPathComponent)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(URLRequest(url: URL(string: strUrl)!), to: destination).downloadProgress { (progress) in
            callback(CGFloat(progress.fractionCompleted), nil)
            }.response { (response) in
                if response.error != nil {
                    callback(nil, response.error)
                }
        }
    }
    
    
    func suspend() {
        oRequest?.suspend()
    }
    
    func resume() {
        oRequest?.resume()
    }
    
    func cancel() {
        oRequest?.cancel()
    }
}
