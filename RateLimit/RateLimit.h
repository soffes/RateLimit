//
//  RateLimit.h
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

@import Foundation;

//! Project version number for RateLimit.
FOUNDATION_EXPORT double RateLimitVersionNumber;

//! Project version string for RateLimit.
FOUNDATION_EXPORT const unsigned char RateLimitVersionString[];


#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
#define NS_ASSUME_NONNULL_END
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Simple utility for only executing code every so often.

 All access to this class is thread-safe.
 */
@interface RateLimit : NSObject

/**
 Executes the given block. If the block has been executed in less time than the limit, it will not be executed.

 @param block The block to be executed. This should not be `nil`.

 @param name A string identifying the block. If more than one block have the same name, their last executed time will be
 stored together. This should not be `nil`.

 @param limit The time interval (in seconds). This should be a positive, non-zero value.

 @return `YES` if the block was executed. `NO` if it was not.

 The time will not be persisted across application launches. The block is synchronously executed on the same
 thread that called this method and not in a GCD queue. If you need to dispatch, simply do that in the block you
 provide.
 */
+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit;

/**
 Resets the time for a given name.

 @param name A string identifying a block's stored time.

 The next time a block with the same name is passed to `executeBlock:name:limit:` it will be executed.
 */
+ (void)resetLimitForName:(NSString *)name;

/**
 Resets the time for all of the names.

 The next time a block with any name is passed to `executeBlock:name:limit:` it will be executed.
 */
+ (void)resetAllLimits;

@end

NS_ASSUME_NONNULL_END
