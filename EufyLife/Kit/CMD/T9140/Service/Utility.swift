//
//  Utility.swift
//  Headset
//
//  Created by AirohaTool on 2016/8/10.
//  Copyright © 2016年 jayfang. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static let sharedInstance = Utility()
    
    func lock(obj: AnyObject, blk:() -> ()) {
        objc_sync_enter(obj)
        blk()
        objc_sync_exit(obj)
    }
    
    func NSDataToInt(data:Data) -> Int {
        var value:Int = 0
        (data as NSData).getBytes(&value, length: data.count)
        return value
    }
    
    func NSDataToInt16( data:Data) -> Int16 {
        var value:Int16 = 0
        (data as NSData).getBytes(&value, length: data.count)
        return value
    }
    
    func IntToNSData(data:Int, length:Int) -> Data {
        var dataI: Int = data
        return Data(bytes: &dataI, count: length)
    }
    
    func UIntToData(data:UInt, length:Int) -> Data {
        var dataI: UInt = data
        return Data(bytes: &dataI, count: length)
    }
    
    func DataToIntArray(data: Data) -> [Int] {
        var value: UInt32 = 0
        let len = MemoryLayout.size(ofValue: value)
        (data as NSData).getBytes(&value, length: len)
        return [Int(value >> 22 & 0x03ff), Int(value >> 14 & 0xff), Int(value >> 7 & 0x7f), Int(value & 0x7f)]
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx ", $0) }.joined()
    }
    
    func scanValue<T>(start: Int, length: Int) -> T {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
    
    func hexEncodedStringNoBlank() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}

///
/// A standard queue (FIFO - First In First Out). Supports simultaneous adding and removing, but only one item can be added at a time, and only one item can be removed at a time.
///
class Queue<T> {
    
    typealias Element = T
    
    var _front: _QueueItem<Element>
    var _back: _QueueItem<Element>
    
    init () {
        // Insert dummy item. Will disappear when the first item is added.
        _back = _QueueItem(nil)
        _front = _back
    }
    
    /// Add a new item to the back of the queue.
    func enqueue (_ value: Element) {
        _back.next = _QueueItem(value)
        _back = _back.next!
    }
    
    /// Return and remove the item at the front of the queue.
    func dequeue () -> Element? {
        if let newhead = _front.next {
            _front = newhead
            return newhead.value
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return _front === _back
    }
    
    func clear() {
        if isEmpty() {
            return
        }
        
        while let _ = dequeue()  {
            // do something with 'value'.
        }
    }
}

extension NSMutableData {
    func appendUInt8(_ value : UInt8) {
        var val = value
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    func appendInt32(_ value : Int32) {
        var val = value.bigEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    func appendInt16(_ value : Int16) {
        var val = value.bigEndian
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    func appendInt8(_ value : Int8) {
        var val = value
        self.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    func appendString(_ value : String) {
        value.withCString {
            self.append($0, length: Int(strlen($0)) + 1)
        }
    }
}


