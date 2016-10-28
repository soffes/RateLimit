//
//  SyncLimiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

public protocol SyncLimiter {
	@discardableResult func execute(_ block: () -> Void) -> Bool
	func reset()
}


extension SyncLimiter {
	public func execute<T>(_ block: () -> T) -> T? {
		var value: T? = nil

		execute {
			value = block()
		}

		return value
	}
}
