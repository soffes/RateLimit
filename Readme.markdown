# SAMRateLimit

Simple utility for only executing code every so often.

This will only execute the block passed for a given `name` if the last time it was called is greater than `limit` or it has never been called.

This is really handy for refreshing stuff in `viewDidAppear:` but preventing it from happening a ton if it was just refreshed.

SAMRateLimit is tested on iOS 6 and requires ARC. It also works on Mac OS X. **Fully thread-safe.** Released under the [MIT license](LICENSE).


## Usage

``` objc
[SAMRateLimit executeBlock:^{
    // Do some work that runs a maximum of once per minute
} name:@"RefreshTimeline" limit:60.0];
```

SAMRateLimit doesn't persist limts across application launches. For most cases, this is ideal. If you need persistence, simply replace `SAMRateLimit` with `SAMPersistentRateLimit` for on disk persistence. Easy as that.

Open up the included [Xcode project](SAMRateLimit.xcodeproj) for an [example app](Example) and [tests](Tests). See the [header](SAMRateLimit/SAMRateLimit.h) for full documentation.


## Installation

Simply add the files in the `SAMRateLimit` directory to your project or add `SAMRateLimit` to your Podfile if you're using CocoaPods.
