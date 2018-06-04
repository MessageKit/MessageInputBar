# CHANGELOG

The changelog for `MessageInputBar`. Also see the [releases](https://github.com/MessageKit/MessageInputBar/releases) on GitHub.

--------------------------------------

## Upcoming release

### Fixed

- Fixed a layout invalidation cycle that never ended. [#1](https://github.com/MessageKit/MessageKit/pull/1) by [@nathantannar4](https://github.com/nathantannar4).

### Added

- Added a new property `shouldForceTextViewMaxHeight` to `MessageInputBar` which forces the view to layout at its maximum height. Use `setShouldForceMaxTextViewHeight(to newValue: Bool, animated: Bool)` to set the property. [#1](https://github.com/MessageKit/MessageKit/pull/1) by [@nathantannar4](https://github.com/nathantannar4).

- **Breaking Change** Added a new protocol `InputItem`. `InputBarButtonItem` now confirms to `InputItem` and the item arrays in `MessageInputBar` are now of type `[InputItem]` for more flexability. [#1](https://github.com/MessageKit/MessageKit/pull/1) by [@nathantannar4](https://github.com/nathantannar4).

## [[Prerelease] 0.1.0](https://github.com/MessageKit/MessageInputBar/releases/tag/0.1.0)

This release forks the development of the `MessageInputBar` from [MessageKit 1.0.0-beta.1](https://github.com/MessageKit/MessageKit/releases/tag/1.0.0-beta.1)
