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

- (void)testLimit {
    BOOL executed = [SAMRateLimit executeBlock:^{
		NSLog(@"Executed");
	} name:@"Test" limit:1.0];
	STAssertTrue(executed, nil);

	executed = [SAMRateLimit executeBlock:^{
		NSLog(@"Executed");
	} name:@"Test" limit:1.0];
	STAssertFalse(executed, nil);

	sleep(1);

	executed = [SAMRateLimit executeBlock:^{
		NSLog(@"Executed");
	} name:@"Test" limit:1.0];
	STAssertTrue(executed, nil);
}

@end
