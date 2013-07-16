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

#pragma mark - NSObject

+ (void)initialize {
    if (self == [SAMRateLimit class]) {
        _dictionary = [[NSMutableDictionary alloc] init];
		_queue = dispatch_queue_create("com.samsoffes.samratelimit", DISPATCH_QUEUE_SERIAL);
    }
}


#pragma mark - Rate Limiting

+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit {
    // Prevent nil parameters
    NSParameterAssert(block);
    NSParameterAssert(name);

	__block BOOL executeBlock = YES;
    dispatch_sync(_queue, ^{
		// Lookup last executed
        NSDate *last = [_dictionary objectForKey:name];
        NSTimeInterval timeInterval = [last timeIntervalSinceNow];

        // If last excuted is less than the limit, don't execute
        if (timeInterval < 0 && fabs(timeInterval) < limit) {
            executeBlock = NO;
        } else {
			[_dictionary setObject:[NSDate date] forKey:name];
		}
	});

	// Execute block
	if (executeBlock) {
		block();
	}
	
	return executeBlock;
}


+ (void)resetLimitForName:(NSString *)name {
    dispatch_sync(_queue, ^{
        [_dictionary removeObjectForKey:name];
    });
}


+ (void)resetAllLimits {
	dispatch_sync(_queue, ^{
        [_dictionary removeAllObjects];
    });
}


#pragma mark - Private

+ (NSMutableDictionary *)_dictionary {
	return _dictionary;
}


+ (dispatch_queue_t)_queue {
	return _queue;
}

@end
