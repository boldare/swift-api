# Change Log

## Upcoming

## [v1.6.2](https://github.com/xsolve-pl/swift-api/tree/1.6.2) (2018-12-06)
- Increased priority of response actions queues.

## [v1.6.1](https://github.com/xsolve-pl/swift-api/tree/1.6.1) (2018-10-03)
- Fixed issues with merging rest service headers.
- Introduced `Error` in `RestResponseDetails` for better internal error handling.

## [v1.6.0](https://github.com/xsolve-pl/swift-api/tree/1.6.0) (2018-10-02)
- Improved `RestResponseCompletionHandler`'s to return more detailed information about response.

## [v1.5.0](https://github.com/xsolve-pl/swift-api/tree/1.5.0) (2018-07-26)
- Improved `ApiService.Configuration` to be able to change most common settings.

## [v1.4.0](https://github.com/xsolve-pl/swift-api/tree/1.4.0) (2018-06-05)
- Updated `RestService` url managing to allow parameters in paths.

## [v1.3.0](https://github.com/xsolve-pl/swift-api/tree/1.3.0) (2018-04-27)
- Added predefined api headers.
- Migrated to swift 4.1

## [v1.2.3](https://github.com/xsolve-pl/swift-api/tree/1.2.3) (2018-03-08)
- Refactored `RequestService` and updated `URLSesion` management.
- Fixed typos.

## [v1.2.2](https://github.com/xsolve-pl/swift-api/tree/1.2.2) (2018-02-20)
- Removed initializer from `ResourcePath` protocol.
- Added `prettyPrintedBody` property to `ApiResponse` to simplify response debugging.

## [v1.2.1](https://github.com/xsolve-pl/swift-api/tree/1.2.1) (2018-02-08)
- Added updating session flag before invalidating it, this should finally fix "Task created in a session that has been invalidated" error.

## [v1.2.0](https://github.com/xsolve-pl/swift-api/tree/1.2.0) (2018-02-05)
- Added `Codable` protocol support.

## [v1.1.10](https://github.com/xsolve-pl/swift-api/tree/1.1.10) (2018-01-03)
- Changed session queue to serial.

## [v1.1.9](https://github.com/xsolve-pl/swift-api/tree/1.1.9) (2017-12-21)
- Moved session management to one synchronous queue.

## [v1.1.8](https://github.com/xsolve-pl/swift-api/tree/1.1.8) (2017-12-11)
- Added protesction before creating task using invalidated session.
- Updated example to work with new completion parameter name.

## [v1.1.7](https://github.com/xsolve-pl/swift-api/tree/1.1.7) (2017-11-10)
- Renamed `completionHandler` parameter to `completion`.
- Added `@discardableResult` annotation to methods in which `useProgress` is set by default to false.

## [v1.1.6](https://github.com/xsolve-pl/swift-api/tree/1.1.6) (2017-11-07)
- Updated project settings to Xcode 9.
- Updated library to use Swift 4.

## [v1.1.5](https://github.com/xsolve-pl/swift-api/tree/1.1.5) (2017-08-03)
- Allowed to change configuration of every api request (Issue [#17](https://github.com/xsolve-pl/swift-api/issues/17))

## [v1.1.4](https://github.com/xsolve-pl/swift-api/tree/1.1.4) (2017-07-18)
- Fixed issue with wrong rest api url when apiPath was empty.

## [v1.1.3](https://github.com/xsolve-pl/swift-api/tree/1.1.3) (2017-04-26)
- Updated description to make library easier to find.

## [v1.1.2](https://github.com/xsolve-pl/swift-api/tree/1.1.2) (2017-04-24)
- Updated readme.

## [v1.1.1](https://github.com/xsolve-pl/swift-api/tree/1.1.1) (2017-04-19)
  - Updated pod homepage url.
  - Updated readme.

## [v1.1.0](https://github.com/xsolve-pl/swift-api/tree/1.1.0) (2017-04-18)
  - Added public RESTLayer introducing support for REST services.
  - Added usage example.
  - Added support for macOS, tvOS and watchOS.
  - Refactored source code.

## [v1.0.0](https://github.com/xsolve-pl/swift-api/tree/1.0.0) (2017-01-31)
  - Created CHANGELOG file.
  - Created public APILayer which created layer of abstraction to HTTPLayer.
  - Created HTTPLayer using URLSesion.
  - Created project.
