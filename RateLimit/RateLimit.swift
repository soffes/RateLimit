//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

public class RateLimit: NSObject {
    
    public class func execute(name name: String,
        limit: NSTimeInterval,
        @noescape block: Void -> ()) -> Bool {
            let delayTime = executionDelay(name: name, limit: limit)
            if delayTime <= 0 {
                block()
                return true
                
            }
            
            return false
    }
    
    public class func executeDeffered(name name:String,
        limit: NSTimeInterval,
        block: Void -> ()) -> Bool {
            let delayTime = executionDelay(name: name, limit: limit)
            if delayTime <= 0 {
                block()
                return true
                
            } else {
                delay(delayTime, block: block)
                return false
            }
    }
    
    public class func resetLimitForName(name: String) {
        dispatch_sync(queue) {
            dictionary.removeValueForKey(name)
        }
    }
    
    public class func resetAllLimits() {
        dispatch_sync(queue) {
            dictionary.removeAll()
        }
    }
    
    // MARK: - Private
    
    static let queue = dispatch_queue_create("com.samsoffes.ratelimit", DISPATCH_QUEUE_SERIAL)
    
    static var dictionary = [String: NSDate]() {
        didSet {
            didChangeDictionary()
        }
    }
    
    class func didChangeDictionary() {
        // Do nothing
    }
    
    private class func recordExecution(name name:String) {
        dispatch_sync(queue) {
            dictionary[name] = NSDate()
        }
    }
    
    private class func executionDelay(name name: String, limit: NSTimeInterval) -> NSTimeInterval {
        var delay: NSTimeInterval = 0
        
        dispatch_sync(queue) {
            // Lookup last executed
            if let lastExecutedAt = dictionary[name] {
                let timeInterval = lastExecutedAt.timeIntervalSinceNow
                
                if (timeInterval < 0 && abs(timeInterval) < limit) {
                    delay = limit - abs(timeInterval)
                }
            }
        }
        
        return delay
    }
    
    private class func delay(delay: NSTimeInterval, block:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), block)
    }
}
