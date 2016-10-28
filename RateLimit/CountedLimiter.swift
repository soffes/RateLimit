//
//  CountedLimiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

public final class CountedLimiter: SyncLimiter {

	// MARK: - Properties

	public let limit: UInt
	public private(set) var count: UInt = 0

	private let syncQueue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])


	// MARK: - Initializers

	public init(limit: UInt) {
		self.limit = limit
	}


	// MARK: - Limiter

	@discardableResult public func execute(_ block: () -> Void) -> Bool {
		let executed = syncQueue.sync { () -> Bool in
			if count < limit {
				count += 1
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
			count = 0
		}
	}
}
