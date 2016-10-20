//
//  Limiter.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

public protocol Limiter {
	func execute(_ block: () -> Void)
	func reset()
}
