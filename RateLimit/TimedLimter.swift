//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

public final class TimedLimiter: SyncLimiter {

	// MARK: - Properties

	public let limit: TimeInterval
	public private(set) var lastExecutedAt: Date?

	private let syncQueue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])


	// MARK: - Initializers

	public init(limit: TimeInterval) {
		self.limit = limit
	}


	// MARK: - Limiter

	@discardableResult public func execute(_ block: () -> Void) -> Bool {
		let executed = syncQueue.sync { () -> Bool in
			let now = Date()

			// Lookup last executed
			let timeInterval = now.timeIntervalSince(lastExecutedAt ?? .distantPast)

			// If the time since last execution is greater than the limit, execute
			if timeInterval > limit {
				// Record execution
				lastExecutedAt = now

				// Execute
				return true
			}

			return false
		}

		if executed {
			block()
		}

		return executed
	}

	public func reset() {
		syncQueue.sync {
			lastExecutedAt = nil
		}
	}
}
