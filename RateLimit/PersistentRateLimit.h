//
//  PersistentRateLimit.h
//  RateLimit
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright © 2013-2015 Sam Soffes. All rights reserved.
//

#import "RateLimit.h"

/**
 Simple utility for only executing code every so often.

 All access to this class is thread-safe.

 This class has the same functionality as `SAMRateLimit` only times are persisted across application launches. The limits
 are separate from non-persisted version.
 */
@interface PersistentRateLimit : RateLimit
@end
