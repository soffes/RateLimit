//
//  DebouncedTests.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import XCTest
import RateLimit

final class DebouncedTests: XCTestCase {
	func testDebouncing() {
		let expecation = self.expectation(description: "executed")
		let queue = DispatchQueue(label: "test-queue")
		let limiter = DebouncedLimiter(limit: 1, queue: queue) {
			expecation.fulfill()
		}

		limiter.execute()
		limiter.execute()
		limiter.execute()

		waitForExpectations(timeout: 2)
	}
}
