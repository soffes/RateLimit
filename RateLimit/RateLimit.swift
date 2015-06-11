//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

@objc public class RateLimit {

    public class func execute(name name: String, limit: NSTimeInterval, block: dispatch_block_t) -> Bool {
        var should: Bool = false
        dispatch_sync(queue) {
            should = shouldExecute(name: name, limit: limit)
        }

        if should {
            block()
        }

        return should
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

    private static let queue = dispatch_queue_create("com.samsoffes.ratelimit", DISPATCH_QUEUE_SERIAL)
    private static var dictionary = [String: NSDate]()

    private class func shouldExecute(name name: String, limit: NSTimeInterval) -> Bool {
        // Lookup last executed
        guard let lastExecutedAt = dictionary[name] else { return true }
        let timeInterval = lastExecutedAt.timeIntervalSinceNow

        // If last excuted is less than the limit, don't execute
        if timeInterval < 0 && abs(timeInterval) < limit {
            return false
        }

        // Record execution
        dictionary[name] = NSDate()
        return true
    }
}
