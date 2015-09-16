//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

public class RateLimit: NSObject {

    public class func execute(name name: String, limit: NSTimeInterval, @noescape block: Void -> ()) -> Bool {
        if shouldExecute(name: name, limit: limit) {
            block()
			return true
        }

        return false
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

    private class func shouldExecute(name name: String, limit: NSTimeInterval) -> Bool {
		var should = false

		dispatch_sync(queue) {
			// Lookup last executed
			if let lastExecutedAt = dictionary[name] {
				let timeInterval = lastExecutedAt.timeIntervalSinceNow

				// If last excuted is less than the limit, don't execute
				should = !(timeInterval < 0 && abs(timeInterval) < limit)
			} else {
				should = true
			}

			// Record execution
			dictionary[name] = NSDate()
		}
		
        return should
    }
}
