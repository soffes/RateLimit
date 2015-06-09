# Rate Limit

Simple utility for only executing code every so often.

This will only execute the block passed for a given `name` if the last time it was called is greater than `limit` or it has never been called.

This is really handy for refreshing stuff in `viewDidAppear:` but preventing it from happening a ton if it was just refreshed.

Rate Limit is **fully thread-safe.** Released under the [MIT license](LICENSE).


## Usage

``` objc
[RateLimit executeBlock:^{
    // Do some work that runs a maximum of once per minute
} name:@"RefreshTimeline" limit:60.0];
```

Rate Limit doesn't persist limts across application launches. For most cases, this is ideal. If you need persistence, simply replace `RateLimit` with `PersistentRateLimit` for on disk persistence. Easy as that.

Open up the included [Xcode project](RateLimit.xcodeproj) for an [example app](Example) and [tests](Tests). See the [header](RateLimit/SAMRateLimit.h) for full documentation.


## Installation

Simply add the files in the `RateLimit` directory to your project or add `RateLimit` to your Podfile if you're using CocoaPods.
