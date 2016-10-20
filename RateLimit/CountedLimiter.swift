//
//  CountedLimiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

public final class CountedLimiter: Limiter {

	// MARK: - Properties

	public let limit: UInt
	public private(set) var count: UInt = 0

	private let queue = DispatchQueue(label: "com.samsoffes.ratelimit", attributes: [])


	// MARK: - Initializers

	public init(limit: UInt) {
		self.limit = limit
	}


	// MARK: - Limiter

	@discardableResult public func execute(_ block: () -> Void) -> Bool {
		var executed = false

		queue.sync {
			if count < limit {
				count += 1
				block()
				executed = true
			}
		}

		return executed
	}

	public func reset() {
		queue.sync {
			count = 0
		}
	}
}
