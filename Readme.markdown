# Rate Limit

[![Version](https://img.shields.io/github/release/soffes/RateLimit.svg)](https://github.com/soffes/RateLimit/releases)
[![Build Status](https://travis-ci.org/soffes/RateLimit.svg?branch=master)](https://travis-ci.org/soffes/RateLimit)
![Swift Version](https://img.shields.io/badge/swift-3.0.1-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/RateLimit.svg)](https://cocoapods.org/pods/RateLimit)

Simple utility for only executing code every so often.

This will only execute the block passed for a given `name` if the last time it was called is greater than `limit` or it has never been called.

This is really handy for refreshing stuff in `viewDidAppear:` but preventing it from happening a ton if it was just refreshed.

Rate Limit is **fully thread-safe.** Released under the [MIT license](LICENSE).


## Usage

We’ll start out with a `TimedLimiter`:

``` swift
// Initialize with a limit of 5, so you can only use this once every 5 seconds.
let refreshTimeline = TimedLimiter(limit: 5)

// Call the work you want to limit by passing a block to the execute method.
refreshTimeline.execute {
    // Do some work that runs a maximum of once per 5 seconds.
}
```

Limiters aren’t persisted across application launches.

### Synchronous Limiters

`TimedLimiter` conforms to the `SyncLimiter` protocol. This means that the block you pass to execute will be called synchronously on the queue you called it from if it should fire. `TimedLimiter` uses time to limit.

`CountedLimiter` is also included. This works by taking a limit as a `UInt` for the maximum number of times to run the block.

The `SyncLimiter` protocol has a really neat extension that let’s you do things like this:

``` swift
let funFactLimiter = CountedLimiter(limit: 2)
let funFact = funFactLimiter.execute { () -> String in
    // Do real things to get a fun fact from a list
    return "Hi"
}
```

Now `funFact` is a `String?`. It’s just an optional of whatever you return from the block. The returned value will be `nil` if the block didn’t run.

You can of course make your own `SyncLimiter`s too!


### Asynchronous Limiter

One `AsyncLimiter` is included. You can make your own too. The included async limiter is `DebouncedLimiter`. This is perfect for making network requests as a user types or other tasks that respond to very frequent events.

The interface is slightly different:

``` swift
let searchLimiter = DebouncedLimiter(limit: 1, block: performSearch)

func textDidChange() {
  searchLimiter.execute()
}
```

You would have to setup the limiter in an initializer since it references an instance method, but you get the idea. The block will be called at most once per second in this configuration.

Pretty easy!

Open up the included [Xcode project](RateLimit.xcodeproj) for an [example app](Example) and [tests](Tests).


## Installation

### Carthage

[Carthage](https://github.com/carthage/carthage) is the recommended way to install Rate Limit. Add the following to your Cartfile:

``` ruby
github "soffes/RateLimit"
```

### CocoaPods

Add the following to your `Podfile`:

``` ruby
pod "RateLimit"
```

Then run `pod install`.
