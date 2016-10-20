

//
//  RateLimitTests.swift
//  RateLimitTests
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright © 2013-2015 Sam Soffes. All rights reserved.
//

import XCTest
import RateLimit

class RateLimitTests: XCTestCase {

	func testLimit() {
		let name = "testLimit"

		// It should get excuted first
		let expectation1 = expectation(description: "Execute 1")
		var reported = RateLimit.execute(name: name, limit: 2) {
			expectation1.fulfill()
		}
		XCTAssertTrue(reported)
		waitForExpectations(timeout: 0, handler: nil)

		// Not right away after
		reported = RateLimit.execute(name: name, limit: 1) {
			XCTFail("This shouldn't have run.")
		}
		XCTAssertFalse(reported)

		// Sleep for a second
		sleep(1)

		// Now it should get executed
		let expectation2 = expectation(description: "Execute 2")
		reported = RateLimit.execute(name: name, limit: 1) {
			expectation2.fulfill()
		}
		XCTAssertTrue(reported)
		waitForExpectations(timeout: 0, handler: nil)
	}

	func testLimitNotResetWhenNotExecuted() {
		let name = "testLimitNotResetWhenNotExecuted"

		// It should get excuted first
		let expectation1 = expectation(description: "Execute 1")
		var reported = RateLimit.execute(name: name, limit: 2) {
			expectation1.fulfill()
		}
		XCTAssertTrue(reported)
		waitForExpectations(timeout: 0, handler: nil)

		// Sleep for a second
		sleep(1)

		// Not right away after
		reported = RateLimit.execute(name: name, limit: 2) {
			XCTFail("This shouldn't have run.")
		}
		XCTAssertFalse(reported)

		// Sleep for a second
		sleep(1)

		// Now it should get executed
		let expectation2 = expectation(description: "Execute 2")
		reported = RateLimit.execute(name: name, limit: 2) {
			expectation2.fulfill()
		}
		XCTAssertTrue(reported)
		waitForExpectations(timeout: 0, handler: nil)
	}

	func testResetting() {
		let name = "testResetting"

		// It should get excuted first
		let expectation1 = expectation(description: "Execute 1")
		let reported1 = RateLimit.execute(name: name, limit: 1) {
			expectation1.fulfill()
		}
		XCTAssertTrue(reported1)
		waitForExpectations(timeout: 0, handler: nil)

		// Not right away after
		let reported2 = RateLimit.execute(name: name, limit: 1) {
			XCTFail("This shouldn't have run.")
		}
		XCTAssertFalse(reported2)

		// Reset limit
		RateLimit.resetLimitForName(name)

		// Now it should get executed
		let expectation2 = expectation(description: "Execute 2")
		let reported3 = RateLimit.execute(name: name, limit: 1) {
			expectation2.fulfill()
		}
		XCTAssertTrue(reported3)
		waitForExpectations(timeout: 0, handler: nil)
	}

	func testResettingAll() {
		// It should get excuted first
		let name1 = "TestResettingAll1"
		let expecation1 = expectation(description: "Execute 1")
		let reported1 = RateLimit.execute(name: name1, limit: 1) {
			expecation1.fulfill()
		}
		XCTAssertTrue(reported1)

		let name2 = "TestResettingAll2"
		let expecation2 = expectation(description: "Execute 2")
		let reported2 = RateLimit.execute(name: name2, limit: 1) {
			expecation2.fulfill()
		}
		XCTAssertTrue(reported2)

		// Not right away after
		let reported3 = RateLimit.execute(name: name1, limit: 1) {
			XCTFail("This shouldn't have run.")
		}
		XCTAssertFalse(reported3)

		let reported4 = RateLimit.execute(name: name2, limit: 1) {
			XCTFail("This shouldn't have run.")
		}
		XCTAssertFalse(reported4)

		// Reset limit
		RateLimit.resetAllLimits()

		// Now it should get executed
		let expectation3 = expectation(description: "Execute 3")
		let reported5 = RateLimit.execute(name: name1, limit: 1) {
			expectation3.fulfill()
		}
		XCTAssertTrue(reported5)

		let expectation4 = expectation(description: "Execute 4")
		let reported6 = RateLimit.execute(name: name2, limit: 1) {
			expectation4.fulfill()
		}
		XCTAssertTrue(reported6)

		waitForExpectations(timeout: 1, handler: nil)
	}
}
