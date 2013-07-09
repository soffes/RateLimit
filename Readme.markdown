# SAMRateLimit

Simple utility for only executing code every so often.

This will only execute the block passed for a given `name` if the last time it was called is greater than `limit` or it has never been called. This is really handy for refreshing stuff in `viewDidAppear:` but preventing it from happening a ton if it was just refreshed.

SAMRateLimit is tested on iOS 6 and requires ARC. It also works on Mac OS X. Released under the [MIT license](LICENSE).

## Usage

``` objc
[SAMRateLimit executeBlock:^{
    // Do some work
} name:@"RefreshTimeline" limit:60.0];
```

See the [header](SAMRateLimit/SAMRateLimit.h) for full documentation.

## Installation

Simply add the files in the `SAMRateLimit.h` and `SAMRateLimit.m` to your project or add `SAMRateLimit` to your Podfile if you're using CocoaPods.
