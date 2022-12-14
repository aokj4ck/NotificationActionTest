//
//  NotificationActionTestUITests.swift
//  NotificationActionTestUITests
//
//  Created by Jack on 12/5/22.
//

import XCTest

extension XCUIElement {
    @discardableResult func assertExists() -> Self {
        let exists = waitForExistence(timeout: 15)
        XCTAssert(exists, "\(title) must exist")

        return self
    }
}

final class NotificationActionTestUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTextResponse() throws {
        /// ---------------------------------------------------------------------
        /// Set up
        let responseText = "I love apps!"

        let app = XCUIApplication()
        app.launch()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        // Allow push notification permissions if applicable
        addUIInterruptionMonitor(withDescription: "Push authorization") { element in
            let allowButton = element.buttons["Allow"].assertExists()
            allowButton.tap()
            return true
        }

        /// ---------------------------------------------------------------------
        /// Notification banner interaction

        let scheduleButton = app.buttons["Schedule push"].firstMatch
        scheduleButton.tap()

        let notification = springboard.otherElements["Notification"]
        let banner = notification.descendants(matching: .any)["NotificationShortLookView"].assertExists()
        banner.press(forDuration: 1.5)

        let textViewCandidates = springboard.descendants(matching: .textView)
        let textViewElement = textViewCandidates.element.assertExists()
        textViewElement.typeText(responseText)

        /// ---------------------------------------------------------------------
        /// Capture banner screenshots for documentation

        let screenshot_springboard = XCTAttachment(screenshot: springboard.screenshot())
        screenshot_springboard.name = "Springboard"
        screenshot_springboard.lifetime = .keepAlways
        add(screenshot_springboard)

        let screenshot_banner = XCTAttachment(screenshot: banner.screenshot())
        screenshot_banner.name = "Banner"
        screenshot_banner.lifetime = .keepAlways
        add(screenshot_banner)

        let screenshot_notif_textView = XCTAttachment(screenshot: textViewElement.screenshot())
        screenshot_notif_textView.name = "Action"
        screenshot_notif_textView.lifetime = .keepAlways
        add(screenshot_notif_textView)

        /// ---------------------------------------------------------------------
        /// Complete the notification action to Application output flow

        let replyButton = springboard.buttons["Send"]
        replyButton.tap()

        let app_response_textView = app.textViews
            .matching(identifier: "ReceivedResponseTextView")
            .element
            .assertExists()
        let app_response_textValue = try XCTUnwrap(app_response_textView.value as? String)

        XCTAssertEqual(app_response_textValue, responseText)

        let applicationResult = XCTAttachment(screenshot: app.screenshot())
        applicationResult.name = "Application"
        applicationResult.lifetime = .keepAlways
        add(applicationResult)

    }
}
