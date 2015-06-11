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
        let name = "TestLimit"
        var reported = false
        var executed = false

        // It should get excuted first
        reported = RateLimit.execute(name: name, limit: 1) {
            executed = true
        }
        XCTAssertTrue(reported)
        XCTAssertTrue(executed)

        // Not right away after
        executed = false
        reported = RateLimit.execute(name: name, limit: 1) {
            executed = true
        }
        XCTAssertFalse(reported)
        XCTAssertFalse(executed)

        // Sleep for a second
        sleep(1)

        // Now it should get executed
        executed = false
        reported = RateLimit.execute(name: name, limit: 1) {
            executed = true
        }
        XCTAssertTrue(reported)
        XCTAssertTrue(executed)
    }


//    - (void)testResetting {
//        NSString *const name = @"TestResetting";
//        BOOL reported = NO;
//        __block BOOL executed = NO;
//
//        // It should get excuted first
//        reported = [RateLimit executeBlock:^{
//            executed = YES;
//        } name:name limit:1.0];
//        XCTAssertTrue(reported);
//        XCTAssertTrue(executed);
//
//        // Not right away after
//        executed = NO;
//        reported = [RateLimit executeBlock:^{
//            executed = YES;
//        } name:name limit:1.0];
//        XCTAssertFalse(reported);
//        XCTAssertFalse(executed);
//
//        // Reset limit
//        [RateLimit resetLimitForName:name];
//
//        // Now it should get executed
//        executed = NO;
//        reported = [RateLimit executeBlock:^{
//            executed = YES;
//        } name:name limit:1.0];
//        XCTAssertTrue(reported);
//        XCTAssertTrue(executed);
//    }
//
//
//    - (void)testResettingAll {
//        NSString *const name1 = @"TestResettingAll1";
//        NSString *const name2 = @"TestResettingAll2";
//        BOOL reported1 = NO;
//        BOOL reported2 = NO;
//        __block BOOL executed1 = NO;
//        __block BOOL executed2 = NO;
//
//        // It should get excuted first
//        reported1 = [RateLimit executeBlock:^{
//            executed1 = YES;
//        } name:name1 limit:1.0];
//        XCTAssertTrue(reported1);
//        XCTAssertTrue(executed1);
//
//        reported2 = [RateLimit executeBlock:^{
//            executed2 = YES;
//        } name:name2 limit:1.0];
//        XCTAssertTrue(reported2);
//        XCTAssertTrue(executed2);
//
//        // Not right away after
//        executed1 = NO;
//        reported1 = [RateLimit executeBlock:^{
//            executed1 = YES;
//        } name:name1 limit:1.0];
//        XCTAssertFalse(reported1);
//        XCTAssertFalse(executed1);
//
//        executed2 = NO;
//        reported2 = [RateLimit executeBlock:^{
//            executed2 = YES;
//        } name:name2 limit:1.0];
//        XCTAssertFalse(reported2);
//        XCTAssertFalse(executed2);
//
//        // Reset limit
//        [RateLimit resetAllLimits];
//
//        // Now it should get executed
//        executed1 = NO;
//        reported1 = [RateLimit executeBlock:^{
//            executed1 = YES;
//        } name:name1 limit:1.0];
//        XCTAssertTrue(reported1);
//        XCTAssertTrue(executed1);
//
//        executed2 = NO;
//        reported2 = [RateLimit executeBlock:^{
//            executed2 = YES;
//        } name:name2 limit:1.0];
//        XCTAssertTrue(reported2);
//        XCTAssertTrue(executed2);
//    }
}
