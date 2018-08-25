//
//  CMDConfig.swift
//  Jouz
//
//  Created by ANKER on 2018/4/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class CMDConfig: NSObject {
    
    private var tempData: Data?
    
    func cmdHead() -> Data {
        return Data(bytes: [0xAC,0x02])
    }
    
    // Response
    
    /// 校验返回指令的头部
    func validateCmdHead(data: Data) -> Bool {
            if data.count > 2 {
                return cmdHead() == data.subdata(in: 0..<2)
            }
        
        return false
    }
    
    func parseCmd(data: Data) -> Data? {
        if data.count > 3 {
            if data[2] == 0xfe {
                if data.count == 8 {
                    if data[3] == 0x1b {
                        return data.subdata(in: 4..<5)
                    } else if data[3] == 0x06 {
                        return data.subdata(in: 4..<5)
                    } else if data[3] == 0x10 {
                        return Data(bytes: [0x01])
                    } else if data[3] == 0x1a {
                        return Data(bytes: [0x01])
                    } else if data[3] == 0x1c {
                        return Data(bytes: [0x01])
                    } else if data[3] == 0x07 || data[3] == 0x08 {
                        return data.subdata(in: 3..<4)
                    }
                } else {
                    return data.subdata(in: 3..<data.count)
                }
            } else if data[2] == 0xf1 && data.count > 7 {
                return data.subdata(in: 3..<7)
            } else if data[2] == 0xfd && data.count > 7 {
                return data.subdata(in: 3..<6)
            } else if data.count > 7 {
                return data.subdata(in: 2..<7)
            }
        }
        return nil
    }
    
    func parseCmds(data: Data) -> [Int: Data]? {
        if data.count >= 8 {
            if validateCmdHead(data: data) {
                tempData = nil
                if let range = data.subdata(in: 2..<data.count).range(of: cmdHead()) {
                    let d1 = data.subdata(in: 0..<range.upperBound)
                    let d2 = data.subdata(in: range.upperBound..<data.count)
                    print("d1: \(d1.hexEncodedStringNoBlank()) d2: \(d2.hexEncodedStringNoBlank())")
                    if let range = d2.subdata(in: 2..<d2.count).range(of: cmdHead()) {
                        let d3 = d2.subdata(in: 0..<range.upperBound)
                        let d4 = d2.subdata(in: range.upperBound..<d2.count)
                        print("d3: \(d3.hexEncodedStringNoBlank()) d4: \(d4.hexEncodedStringNoBlank())")
                        if d4.count >= 8 {
                            return [parseCMD(data: d1) : d1, parseCMD(data: d3) : d3, parseCMD(data: d4) : d4]
                        } else {
                            tempData = d4
                            return [parseCMD(data: d1) : d1, parseCMD(data: d3) : d3]
                        }
                    } else {
                        return [parseCMD(data: d1) : d1, parseCMD(data: d2) : d2]
                    }
                } else {
                    return [parseCMD(data: data) : data]
                }
            } else {
                if tempData != nil {
                    let d = NSMutableData()
                    d.append(tempData!)
                    d.append(data)
                    tempData = nil
                    return parseCmds(data: d as Data)
                } else {
                    if let range = data.range(of: cmdHead()) {
                        return parseCmds(data: data.subdata(in: range.lowerBound..<data.count))
                    } 
                }
            }
            
        }
        return nil
    }
    
    func parseCMD(data: Data) -> Int {
        if data.count > 3 {
            if data[2] == 0xfe {
                if data.count == 8 {
                    if data[3] == 0x1b {
                        return 0x1b
                    } else if data[3] == 0x06 {
                        return 0x06
                    } else if data[3] == 0x10 {
                        return 0x10
                    } else if data[3] == 0x1a {
                        return 0x1a
                    } else if data[3] == 0x1c {
                        return 0x1c
                    } else if data[3] == 0x07 || data[3] == 0x08 {
                        return 0xf2
                    }
                } else {
                    return 0x00
                }
            } else if data[2] == 0xf1 {
                return 0xf1
            } else if data[2] == 0xfd {
                return 0xfd
            } else {
                return 0xfe
            }
        }
        return 0xff
    }
    
    func checkSum(data: Data) -> UInt8 {
        let sum = data.map{Int($0)}.reduce(0,+)
        return UInt8(sum & 0xff)
    }
    
    func addPrefix(cmd: Int) -> UInt8 {
        let c = T9140CMD(rawValue: cmd)
        if c == .syncLoalTime {
            return 0x00
        } else {
            return 0xfe
        }
    }
    
    func addSupfix(cmd: Int) -> UInt8 {
        let c = T9140CMD(rawValue: cmd)
        if c == .getHistoryData {
            return 0xcf
        } else {
            return 0xcc
        }
    }
    
    func validateCheckSum(data: Data) -> Bool {
        let subData = data.subdata(in: 2..<data.count-1)
        print("checkSum: \(subData.hexEncodedStringNoBlank())")
        return checkSum(data: subData) == data.last
    }
    
}
