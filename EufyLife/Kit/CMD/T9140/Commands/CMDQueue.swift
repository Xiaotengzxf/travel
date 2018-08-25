//
//  CMDQueue.swift
//  Headset
//
//  Created by AirohaTool on 2016/8/10.
//  Copyright © 2016年 jayfang. All rights reserved.
//

import Foundation

class CMDQueue {
    
    static let sharedInstance = CMDQueue()
    var thQueue : CMDQueueThread? = nil

    func AddCmdQueue(cmd: Int, param: Data?, toQueue: Bool) {
        if thQueue == nil {
            thQueue = CMDQueueThread()
            thQueue?.start()
        }
        if toQueue {
            thQueue?.enqueue(cmd: cmd, param: param)
        } else {
            thQueue?.excuteCmd(cmd: cmd, parameter: param, toQueue: toQueue)
        }
    }
    
    func stop() {
        thQueue?.stop()
        thQueue = nil
    }
    
    func clearCmdQueue() {
        thQueue?.cleanCmdQueue()
    }
}

class CMDQueueThread {
    
    let _qCmds = Queue<(Int, Data?)>()
    var _threadTimer:DispatchSourceTimer!
    var _createQueue = DispatchQueue(label: "com.zhangxiaofei.app.JouzHeadset_CmdQueue", attributes: [])
    var _stopflag = true
    
    func cleanCmdQueue() {
        Utility.sharedInstance.lock(obj: _qCmds) {
            self._qCmds.clear()
        }
    }
    
    func enqueue(cmd: Int, param: Data?) {
        Utility.sharedInstance.lock(obj: _qCmds) {
            self._qCmds.enqueue((cmd, param))
        }
    }
    
    func isQueueEmpty() -> Bool {
        var isEmpty = true
        Utility.sharedInstance.lock(obj: _qCmds) {
            isEmpty = self._qCmds.isEmpty()
        }
        return isEmpty
    }
    
    func protected_dequeue () {
        while !isQueueEmpty() {
            if !BLEPeripheral.sharedInstance.isPeripheralValid() {
                Utility.sharedInstance.lock(obj: _qCmds) {
                    self._qCmds.clear()
                }
                return
            }
            
            if _stopflag {
                return
            }
            
            if lockCenter.sharedInstance.isLocked() {
                Thread.sleep(forTimeInterval: 0.1)
                continue
            }
            
            Utility.sharedInstance.lock(obj: _qCmds) {
                if self.isQueueEmpty() {
                    return
                }
                
                if let cmd = self._qCmds.dequeue() {
                    self.excuteCmd(cmd: cmd.0, parameter: cmd.1, toQueue: true)
                }
            }
        }
    }
    
    func excuteCmd(cmd: Int, parameter: Data?, toQueue: Bool) {
        let cmdBase = JCMDManager.sharedInstance.getCMDBase(cmd: cmd)
        cmdBase?.sendCmd(parameter: parameter, toQueue: toQueue)
    }
    
    func start() {
        _stopflag = false
        
        if _threadTimer == nil {
            let interval : DispatchTimeInterval = .milliseconds(100)
            _threadTimer = DispatchSource.makeTimerSource(queue: _createQueue)
            _threadTimer.schedule(deadline: .now(), repeating: interval)
            _threadTimer.setEventHandler(handler: {
                if !self._stopflag {
                    self.protected_dequeue()
                }
            })
            _threadTimer.resume()
        }

    }
    
    func stop() {
        _stopflag = true
        self._threadTimer.cancel()
        self._threadTimer = nil
    }
}
