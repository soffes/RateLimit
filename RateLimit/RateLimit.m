//
//  RateLimit.m
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

#import "RateLimit.h"

@implementation RateLimit

#pragma mark - Rate Limiting

+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit {
	// Prevent nil parameters
	NSParameterAssert(block);
	NSParameterAssert(name);

	__block BOOL executeBlock = YES;
	dispatch_sync([self queue], ^{
		// Lookup last executed
		NSDate *last = [[self dictionary] objectForKey:name];
		NSTimeInterval timeInterval = [last timeIntervalSinceNow];

		// If last executed is less than the limit, don't execute
		if (timeInterval < 0 && fabs(timeInterval) < limit) {
			executeBlock = NO;
		} else {
			[[self dictionary] setObject:[NSDate date] forKey:name];
		}
	});

	// Execute block
	if (executeBlock) {
		block();
    block = nil;
	}

	return executeBlock;
}


+ (void)resetLimitForName:(NSString *)name {
	NSParameterAssert(name);
	
	dispatch_sync([self queue], ^{
		[[self dictionary] removeObjectForKey:name];
	});
}


+ (void)resetAllLimits {
	dispatch_sync([self queue], ^{
		[[self dictionary] removeAllObjects];
	});
}


#pragma mark - Private

+ (NSMutableDictionary *)dictionary {
	static NSMutableDictionary *dictionary = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dictionary = [[NSMutableDictionary alloc] init];
	});
	return dictionary;
}


+ (dispatch_queue_t)queue {
	static dispatch_queue_t queue = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		queue = dispatch_queue_create("com.samsoffes.samratelimit", DISPATCH_QUEUE_SERIAL);
	});
	return queue;
}

@end
