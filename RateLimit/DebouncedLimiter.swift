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
	public let block: (() -> Void)?
	public let queue: DispatchQueue

	private var workItem: DispatchWorkItem?
	private let syncQueue = DispatchQueue(label: "com.samsoffes.ratelimit.debounced", attributes: [])


	// MARK: - Initializers

	public init(limit: TimeInterval, queue: DispatchQueue = .main, block: (() -> Void)? = nil) {
		self.limit = limit
		self.block = block
		self.queue = queue
	}


	// MARK: - Limiter

	public func execute(_ block: @escaping () -> Void) {
		syncQueue.async { [weak self] in
			if let workItem = self?.workItem {
				workItem.cancel()
				self?.workItem = nil
			}

			guard let queue = self?.queue,
				let limit = self?.limit
			else { return }

			let workItem = DispatchWorkItem(block: block)
			queue.asyncAfter(deadline: .now() + limit, execute: workItem)

			self?.workItem = workItem
		}
	}

	public func execute() {
		guard let block = block else { assertionFailure("Block never assigned!"); return }
		execute(block)
	}

	public func reset() {
		syncQueue.async { [weak self] in
			if let workItem = self?.workItem {
				workItem.cancel()
				self?.workItem = nil
			}
		}
	}
}
