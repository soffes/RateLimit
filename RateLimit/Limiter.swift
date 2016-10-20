//
//  Limiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

public protocol Limiter {
	@discardableResult func execute(_ block: () -> Void) -> Bool
	func reset()
}
