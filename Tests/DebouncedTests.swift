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

		var executedValue: Int?
		var currentValue = 1

		let limiter = DebouncedLimiter(limit: 1) {
			executedValue = currentValue
			expecation.fulfill()
		}

		limiter.execute()

		currentValue = 2
		limiter.execute()

		currentValue = 3
		limiter.execute()

		waitForExpectations(timeout: 2)

		XCTAssertEqual(3, executedValue)
	}
}
