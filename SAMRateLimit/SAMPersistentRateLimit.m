//
//  SAMPersistentRateLimit.m
//  SAMRateLimit
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

#import "SAMPersistentRateLimit.h"

@interface SAMRateLimit (Private)
+ (dispatch_queue_t)queue;
@end

@implementation SAMPersistentRateLimit

+ (BOOL)executeBlock:(void(^)(void))block name:(NSString *)name limit:(NSTimeInterval)limit {
	BOOL result = [super executeBlock:block name:name limit:limit];
	[self writeDictionary];
	return result;
}


+ (void)resetLimitForName:(NSString *)name {
	[super resetLimitForName:name];
	[self writeDictionary];
}


+ (void)resetAllLimits {
	[super resetAllLimits];
	[self writeDictionary];
}


#pragma mark - Private

+ (NSURL *)fileURL {
	static NSURL *fileURL = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		fileURL = [documentsDirectory URLByAppendingPathComponent:@"SAMPersistentRateLimit.plist"];
	});
	return fileURL;
}


+ (NSMutableDictionary *)dictionary {
	static NSMutableDictionary *persistedDictionary = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		persistedDictionary = [[NSMutableDictionary alloc] initWithContentsOfURL:[self fileURL]];
		if (!persistedDictionary) {
			persistedDictionary = [[NSMutableDictionary alloc] init];
		}
	});
	return persistedDictionary;
}


+ (void)writeDictionary {
	dispatch_async([self queue], ^{
		[[self dictionary] writeToURL:[self fileURL] atomically:YES];
	});
}

@end
