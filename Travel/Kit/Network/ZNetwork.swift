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
    
    func request(strUrl: String, strMethod: String, parameters: [String : Any
        ]?, headers: [String : String]?, queue: QueueType = .main, callback: @escaping (String?, Error?)->()) {
        self.request(strUrl: strUrl, strMethod: strMethod, parameters: parameters, encoding: Encoding.jsonBody.toUrlEncoding(), headers: headers, queue: queue, callback: callback)
    }
    
    func request(strUrl: String, strMethod: String, parameters: [String : Any
        ]?,encoding: ParameterEncoding, headers: [String : String]?, queue: QueueType = .main, callback: @escaping (String?, Error?)->()) {
        log.info("[\(strUrl)] [\(String(describing: headers))] [\(String(describing: parameters))]")
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        oRequest = manager.request(strUrl, method: HTTPMethod(rawValue: strMethod) ?? .get, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: { (response) in
            if let data = response.result.value {
                let value = String(data: data, encoding: .utf8)
                log.info("[\(strUrl)] [\(String(describing: value))]")
                callback(value, response.error)
            } else {
                callback(nil, response.error)
            }
        })
    }
    
    func upload(data: Data, url: URLConvertible, queue: DispatchQueue?) {
        oRequest = Alamofire.upload(data, to: url).responseData(queue: queue) { (response) in
            
        }
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
