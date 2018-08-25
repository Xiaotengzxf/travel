//
//  JCMDManager.swift
//  Jouz
//
//  Created by ANKER on 2018/4/16.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCMDManager: NSObject {
    
    static let sharedInstance = JCMDManager()
    private var cmdList : [Int: CMDBase] = [:]
    
    
    // MARK: - Private
    
    private func addCMD(cmd: Int, base: CMDBase) {
        if let _ = cmdList[cmd] {
            
        } else {
            cmdList[cmd] = base
        }
    }
    
    // MARK: - Public
    
    // 将指令初始化并添加至队列中
    public func initialCMDs(cmds: [Int]) {
        for cmd in cmds {
            addCMD(cmd: cmd, base: CMDBase(cmd: cmd))
        }
    }
    
    // MARK: - Public
    
    func getCMDBase(cmd: Int) -> CMDBase? {
        return cmdList[cmd]
    }
}
