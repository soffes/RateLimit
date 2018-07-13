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
	public func execute<T>(_ block: () throws -> T) rethrows -> T? {
		var value: T? = nil

		try execute {
			value = try block()
		}

		return value
	}
}
