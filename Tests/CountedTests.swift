//
//  CountedTests.swift
//  RateLimit
//
//  Created by Sam Soffes on 10/20/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import XCTest
import RateLimit

final class CountedTests: XCTestCase {
	func testCounting() {
		let limiter = CountedLimiter(limit: 2)
		XCTAssertEqual(0, limiter.count)

		let one = expectation(description: "one")
		limiter.execute {
			one.fulfill()
		}
		XCTAssertEqual(1, limiter.count)

		let two = expectation(description: "two")
		limiter.execute {
			two.fulfill()
		}
		XCTAssertEqual(2, limiter.count)

		limiter.execute {
			XCTFail("This shouldn't run.")
		}
		XCTAssertEqual(2, limiter.count)

		waitForExpectations(timeout: 1)
	}

	func testReturn() {
		let limiter = CountedLimiter(limit: 1)

		let one = expectation(description: "one")
		let value1 = limiter.execute { () -> Int in
			one.fulfill()
			return 42
		}

		XCTAssertEqual(42, value1)

		let value2 = limiter.execute { () -> Int in
			return 19
		}

		XCTAssertNil(value2)

		waitForExpectations(timeout: 0)
	}
}
