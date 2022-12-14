# NotificationActionTest

This project provides a reference implementation of `UNTextInputNotificationAction` and `XCTestCase` with `XCUIApplication` to ensure that notification actions using text responses are propagated correctly through an application.

### Inspiration

This project was inspired by [joern's reference blog post][1] and [stackoverflow answer][2] that used [NWPusher][3] and a device to test notifications in Xcode 9. In the five Xcode versions later the iOS simulator has added support for more notifications. Additionally I wanted a reference without relying on NWPusher and setting up external push  infrastructure. This approach should be compatible with any existing UI test infrastructure that uses true remote notifications.

## Usage

1. Build and run the project with Xcode 14
2. Run the tests in NotificationActionTestUITests.testTextResponse to validate text response actions.

### Key Notification Action Concepts

1. `NotificationRegisterModel.registerCategory()` registers a `UNTextInputNotificationAction` and allows you to act on notifications.
2. `NotificationResponseModel` implements
    - `userNotificationCenter(, willPresent:, withCompletionHandler:)` to show notifications while the app is in the foreground for testing convenience.
    - `userNotificationCenter(, didReceive:, withCompletionHandler:)` forwards the response to `ViewController.display(response:)` for a complete flow.
3. `ViewController.schedulePush()` starts the lifecycle by sending a local notification that can be acted on.

### Key Testing Concepts

1. Capture a reference to the springboard process `XCUIApplication(bundleIdentifier: "com.apple.springboard")`
2. Accept push permissions with `addUIInterruptionMonitor`
3. Query for springboard's element `"NotificationShortLookView"` to act on the notification banner.
3. Query for springboard's only `textView` element to act on the action response text input.
    - Note: This is not a text field. Multiple lines are supported input!
4. Lastly the text entered through the springboard UI hierarchy is compared against the app's UI hierarchy to ensure completeness.

### Localization

The base localization is en\_US.

## Authors

- [Jack Alto](https://github.com/aokj4ck)

## License

[BSD 3-Clause License](LICENSE)

[1]: https://www.pixeldock.com/blog/testing-push-notifications-with-xcode-uitests/
[2]: https://stackoverflow.com/questions/44986454/ios-using-push-notifications-in-uitests-target
[3]: https://github.com/noodlewerk/NWPusher
