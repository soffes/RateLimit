//
//  DebouncedLimiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

public final class DebouncedLimiter: AsyncLimiter {

	// MARK: - Properties

	public let limit: TimeInterval
	public let block: () -> Void
	public let queue: DispatchQueue

	private var lastExecutedAt: DispatchTime?
	private let syncQueue = DispatchQueue(label: "com.samsoffes.ratelimit.debounced", attributes: [])


	// MARK: - Initializers

	public init(limit: TimeInterval, queue: DispatchQueue = .main, block: @escaping () -> Void) {
		self.limit = limit
		self.block = block
		self.queue = queue
	}


	// MARK: - Limiter

	public func execute() {
		syncQueue.async { [weak self] in
			guard let queue = self?.queue,
				let limit = self?.limit
			else { return }

			let now = DispatchTime.now()

			if self?.lastExecutedAt == nil {
				self?.lastExecutedAt = now
			}

			queue.asyncAfter(deadline: now + limit) {
				guard let lastExecutedAt = self?.lastExecutedAt else { return }

				let now = DispatchTime.now()

				if now >= lastExecutedAt + limit {
					self?.block()
					self?.lastExecutedAt = now
				}
			}
		}
	}

	public func reset() {
		syncQueue.async { [weak self] in
			self?.lastExecutedAt = nil
		}
	}
}
