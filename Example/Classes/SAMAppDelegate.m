//
//  SAMAppDelegate.m
//  SAMRateLimit
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

#import "SAMAppDelegate.h"
#import "SAMExampleViewController.h"

@implementation SAMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[SAMExampleViewController alloc] init];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
