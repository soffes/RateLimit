//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

open class RateLimit: NSObject {

    @discardableResult open class func execute(name: String, limit: TimeInterval, block: (Void) -> ()) -> Bool {
        if shouldExecute(name: name, limit: limit) {
            block()
			return true
        }

        return false
    }

    open class func resetLimitForName(_ name: String) {
        queue.sync {
            let _ = dictionary.removeValue(forKey: name)
        }
    }

    open class func resetAllLimits() {
        queue.sync {
            dictionary.removeAll()
        }
    }


    // MARK: - Private

    static let queue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])

	static var dictionary = [String: Date]() {
		didSet {
			didChangeDictionary()
		}
	}

	class func didChangeDictionary() {
		// Do nothing
	}

    fileprivate class func shouldExecute(name: String, limit: TimeInterval) -> Bool {
		var should = false

		queue.sync {
			// Lookup last executed
			if let lastExecutedAt = dictionary[name] {
				let timeInterval = lastExecutedAt.timeIntervalSinceNow

				// If last excuted is less than the limit, don't execute
				should = !(timeInterval < 0 && abs(timeInterval) < limit)
			} else {
				should = true
			}

			// Record execution
			dictionary[name] = Date()
		}
		
        return should
    }
}
