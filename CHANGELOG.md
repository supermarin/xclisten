# Changelog

# 0.0.7

##### Enhancements

* Forgot to escape schemes & workspaces in 0.0.6. done.


# 0.0.6

##### Enhancements

* Added iPads (`xclisten -d [ipad2, ipad4, ipad_air]`)

# 0.0.5

##### Bug Fixes

* Fixed workspace and device flags


# 0.0.4

##### Enhancements

* Search for `.xcworkspace` recursively |
  [Delisa Mason](https://github.com/kattrali) |
  [#8](https://github.com/mneorr/xclisten/pull/8)
* Added some tests and CI integration \o/
* Added `--workspace -w` flag to specify a custom workspace location
* Specified `macosx` sdk rather than nothing on OSX builds


# 0.0.3

##### Enhancements

* Use lower-level fork and exec for spawning xcodebuild
* Support for custom schemes
* Support for custom devices (iphone5s, iphone5, iphone4)

# 0.0.2

##### Bug Fixes

* Kill child processes on Ctrl-C


# 0.0.1

* Initial release

