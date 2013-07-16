//
//  SAMPersistentRateLimit.h
//  SAMRateLimit
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

#import "SAMRateLimit.h"

/**
 Simple utility for only executing code every so often.

 All access to this class is thread-safe.
 
 This class has the same funtionality as `SAMRateLimit` only times are presisted across application launches. The limits
 are separate from non-persisted version.
 */
@interface SAMPersistentRateLimit : SAMRateLimit
@end
