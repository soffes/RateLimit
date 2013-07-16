//
//  SAMRateLimit.m
//  SAMRateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012-2013 Sam Soffes. All rights reserved.
//

#import "SAMRateLimit.h"

static NSMutableDictionary *_dictionary = nil;

@implementation SAMRateLimit

+ (void)initialize {
    if (self = [SAMRateLimit class]) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
}

+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit {
    // Prevent nil parameters
    NSParameterAssert(block);
    NSParameterAssert(name);

    NSDate *last = nil;
    @synchronized(self) {
        // Lookup last executed
        last = [_dictionary objectForKey:name];

        NSTimeInterval timeInterval = [last timeIntervalSinceNow];

        // If last excuted is less than the limit, don't execute
        if (timeInterval < 0 && fabs(timeInterval) < limit) {
            return NO;
        }

        [_dictionary setObject:[NSDate date] forKey:name];
    }

	// Execute
	block();
	return YES;
}


+ (void)resetLimitForName:(NSString *)name {
    @synchronized(self) {
        [_dictionary removeObjectForKey:name];
    }
}


+ (void)resetAllLimits {
    @synchronized(self) {
        [_dictionary removeAllObjects];
    }
}

@end
