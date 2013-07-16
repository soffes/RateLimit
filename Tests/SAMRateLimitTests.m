//
//  SAMRateLimitTests.m
//  SAMRateLimitTests
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

#import "SAMRateLimitTests.h"
#import "SAMRateLimit.h"

@implementation SAMRateLimitTests

- (void)testRequiredParameters {
	STAssertThrows([SAMRateLimit executeBlock:nil name:@"Foo" limit:1.0], nil);
	STAssertThrows([SAMRateLimit executeBlock:^{} name:nil limit:1.0], nil);
}


- (void)testLimit {
	NSString *const name = @"TestLimit";
	BOOL reported = NO;
	__block BOOL executed = NO;

	// It should get excuted first
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertTrue(reported, nil);
	STAssertTrue(executed, nil);

	// Not right away after
	executed = NO;
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertFalse(reported, nil);
	STAssertFalse(executed, nil);

	// Sleep for a second
	sleep(1);

	// Now it should get executed
	executed = NO;
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertTrue(reported, nil);
	STAssertTrue(executed, nil);
}


- (void)testResetting {
	NSString *const name = @"TestResetting";
	BOOL reported = NO;
	__block BOOL executed = NO;

	// It should get excuted first
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertTrue(reported, nil);
	STAssertTrue(executed, nil);

	// Not right away after
	executed = NO;
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertFalse(reported, nil);
	STAssertFalse(executed, nil);

	// Reset limit
	[SAMRateLimit resetLimitForName:name];

	// Now it should get executed
	executed = NO;
	reported = [SAMRateLimit executeBlock:^{
		executed = YES;
	} name:name limit:1.0];
	STAssertTrue(reported, nil);
	STAssertTrue(executed, nil);
}


- (void)testResettingAll {
	NSString *const name1 = @"TestResettingAll1";
	NSString *const name2 = @"TestResettingAll2";
	BOOL reported1 = NO;
	BOOL reported2 = NO;
	__block BOOL executed1 = NO;
	__block BOOL executed2 = NO;

	// It should get excuted first
	reported1 = [SAMRateLimit executeBlock:^{
		executed1 = YES;
	} name:name1 limit:1.0];
	STAssertTrue(reported1, nil);
	STAssertTrue(executed1, nil);

	reported2 = [SAMRateLimit executeBlock:^{
		executed2 = YES;
	} name:name2 limit:1.0];
	STAssertTrue(reported2, nil);
	STAssertTrue(executed2, nil);

	// Not right away after
	executed1 = NO;
	reported1 = [SAMRateLimit executeBlock:^{
		executed1 = YES;
	} name:name1 limit:1.0];
	STAssertFalse(reported1, nil);
	STAssertFalse(executed1, nil);

	executed2 = NO;
	reported2 = [SAMRateLimit executeBlock:^{
		executed2 = YES;
	} name:name2 limit:1.0];
	STAssertFalse(reported2, nil);
	STAssertFalse(executed2, nil);

	// Reset limit
	[SAMRateLimit resetAllLimits];

	// Now it should get executed
	executed1 = NO;
	reported1 = [SAMRateLimit executeBlock:^{
		executed1 = YES;
	} name:name1 limit:1.0];
	STAssertTrue(reported1, nil);
	STAssertTrue(executed1, nil);

	executed2 = NO;
	reported2 = [SAMRateLimit executeBlock:^{
		executed2 = YES;
	} name:name2 limit:1.0];
	STAssertTrue(reported2, nil);
	STAssertTrue(executed2, nil);
}

@end
