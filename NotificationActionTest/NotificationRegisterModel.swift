//
//  NotificationRegisterModel.swift
//  NotificationActionTest
//
//  Created by Jack on 12/5/22.
//

import Foundation
import UserNotifications

struct NotificationRegisterModel {
    enum Categories {
        static let main = "notification-category"
    }

    enum Actions {
        static let main = "text-response"
    }

    static func requestAuth(delegate: UNUserNotificationCenterDelegate) {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.delegate = delegate

        notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { result, error in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
            })
    }

    static func registerCategory() {
        let textResponseAction = UNTextInputNotificationAction(identifier: Actions.main,
                                                               title: "Respond",
                                                               icon: UNNotificationActionIcon(systemImageName: "text.bubble"))

        let notificationCategory = UNNotificationCategory(identifier: Categories.main,
                                                          actions: [textResponseAction],
                                                          intentIdentifiers: [],
                                                          hiddenPreviewsBodyPlaceholder: nil,
                                                          categorySummaryFormat: nil)

        UNUserNotificationCenter.current().setNotificationCategories([
            notificationCategory
        ])
    }
}
