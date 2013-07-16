//
//  SAMRateLimit.m
//  SAMRateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012-2013 Sam Soffes. All rights reserved.
//

#import "SAMRateLimit.h"

@implementation SAMRateLimit

static NSMutableDictionary *_dictionary = nil;
static dispatch_queue_t _queue = nil;

#pragma mark - Rate Limiting

+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit {
    // Prevent nil parameters
    NSParameterAssert(block);
    NSParameterAssert(name);

	__block BOOL executeBlock = YES;
    dispatch_sync([self _queue], ^{
		// Lookup last executed
        NSDate *last = [[self _dictionary] objectForKey:name];
        NSTimeInterval timeInterval = [last timeIntervalSinceNow];

        // If last excuted is less than the limit, don't execute
        if (timeInterval < 0 && fabs(timeInterval) < limit) {
            executeBlock = NO;
        } else {
			[[self _dictionary] setObject:[NSDate date] forKey:name];
		}
	});

	// Execute block
	if (executeBlock) {
		block();
	}
	
	return executeBlock;
}


+ (void)resetLimitForName:(NSString *)name {
    dispatch_sync([self _queue], ^{
        [[self _dictionary] removeObjectForKey:name];
    });
}


+ (void)resetAllLimits {
	dispatch_sync([self _queue], ^{
        [[self _dictionary] removeAllObjects];
    });
}


#pragma mark - Private

+ (NSMutableDictionary *)_dictionary {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_dictionary = [[NSMutableDictionary alloc] init];
	});
	return _dictionary;
}


+ (dispatch_queue_t)_queue {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_queue = dispatch_queue_create("com.samsoffes.samratelimit", DISPATCH_QUEUE_SERIAL);
	});
	return _queue;
}

@end
