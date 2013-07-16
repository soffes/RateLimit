//
//  SAMExampleViewController.m
//  SAMRateLimit
//
//  Created by Sam Soffes on 7/15/13.
//  Copyright (c) 2013 Sam Soffes. All rights reserved.
//

#import "SAMExampleViewController.h"
#import "SAMRateLimit.h"

@interface SAMExampleViewController ()
@property (nonatomic, readonly) UILabel *textLabel;
@end

@implementation SAMExampleViewController

#pragma mark - Accessors

@synthesize textLabel = _textLabel;

- (UILabel *)textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 40.0f)];
		_textLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _textLabel;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

	[self.view addSubview:self.textLabel];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(20.0f, 80.0f, 280.0f, 40.0f);
	[button setTitle:@"Execute" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}


#pragma mark - Actions

- (void)execute:(id)sender {
	[SAMRateLimit executeBlock:^{
		self.textLabel.text = [[NSDate date] description];
	} name:@"Example" limit:3.0];
}

@end
