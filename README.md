# XCListen
[![Build Status](https://travis-ci.org/supermarin/xclisten.png?branch=master)](https://travis-ci.org/supermarin/xclisten)
[![Code Climate](https://codeclimate.com/github/supermarin/xclisten.png)](https://codeclimate.com/github/supermarin/xclisten)

A __zero-configuration__ file watcher for ObjectiveC.


It:
- runs tests each time you save a file
- runs `pod install` each time you save the Podfile
- formats your tests with RSpec-style output using [XCPretty](https://github.com/supermarin/xcpretty)


## Installation

```
$ gem install xclisten
```

## Usage

Run this command from the root of your repository:
```
$ xclisten
```
Simple, huh?

![](http://i.imgur.com/JpsMMBW.gif)

If you have an OSX project, you'll want to run it with `--osx` flag.

## Flags

``` bash
Usage: xclisten [optional flags]
        --osx                        Run with OSX sdk (without simulator)
        --ios                        [DEFAULT] Run with iOS sdk
    -d, --device                     Simulated device [iphone5s, iphone5, iphone4, ipad2, ipad4, ipad_air]. Default is iphone5s
    -s, --scheme SCHEME              BYOS (Bring your own scheme)
    -w, --workspace WORKSPACE        BYOW (Bring your own workspace)
    -h, --help                       Show this message
    -v, --version                    Show version
```

## Something went wrong!

No worries, just `tail -f xcodebuild_error.log` and let us know what's happening.

## Acknowledgements

This project is inspired by many general-purpose listeners out there,
such as [kicker](https://github.com/alloy/kicker) and [Guard](https://github.com/guard/guard).


## TODO

- Support non-cocoapods projects, when there's no .xcworkspace
- Acceptance tests
