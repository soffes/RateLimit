//
//  Legacy.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

/// Legacy interface.
///
/// The only difference between this deprecated wrapper and the previous version is once a limit is set, it cannot be
/// changed. Whatever limit is set first, will be used for all subsequent calls.
@available(*, deprecated: 2.0.0, message: "use TimedLimiter")
public class RateLimit: NSObject {

	// MARK: - Properties

	private static let queue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])

	private static var dictionary = [String: TimedLimiter]()


	// MARK: - Execution

	@discardableResult public class func execute(name: String, limit: TimeInterval, block: () -> Void) -> Bool {
		var executed = false

		queue.sync {
			let limiter = dictionary[name] ?? {
				let limiter = TimedLimiter(limit: limit)
				dictionary[name] = limiter
				return limiter
			}()

			executed = limiter.execute(block)
		}

		return executed
	}


	// MARK: - Limiting

	public static func resetLimitForName(_ name: String) {
		queue.sync {
			let _ = dictionary.removeValue(forKey: name)
		}
	}

	public static func resetAllLimits() {
		queue.sync {
			dictionary.removeAll()
		}
	}
}
