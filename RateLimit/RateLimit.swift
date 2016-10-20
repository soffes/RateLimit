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
		var executed = false

		queue.sync {
			let now = Date()

			// Lookup last executed
			let timeInterval = now.timeIntervalSince(dictionary[name] ?? .distantPast)

			// If the time since last execution is greater than the limit, execute
			if timeInterval > limit {
				// Record execution
				dictionary[name] = now

				// Execute
				block()
				executed = true
			}
		}

		return executed
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


	// MARK: - Internal

	static let queue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])

	static var dictionary = [String: Date]() {
		didSet {
			didChangeDictionary()
		}
	}

	class func didChangeDictionary() {
		// Do nothing
	}
}
