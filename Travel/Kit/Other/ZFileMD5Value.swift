//
//  ZFileMD5Value.swift
//  Jouz
//
//  Created by ANKER on 2018/1/22.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class ZFileMD5Value: NSObject {
    
    func md5File(url: URL) -> String? {
        let bufferSize = 1024 * 1024
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            //初始化内容
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
            //计算Md5摘要
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &context)
            }
            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
    }
    
}
