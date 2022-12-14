//
//  NotificationResponseModel.swift
//  NotificationActionTest
//
//  Created by Jack on 12/5/22.
//

import Foundation
import UserNotifications

typealias OutputBlock = (String) -> Void

class NotificationResponseModel: NSObject, UNUserNotificationCenterDelegate {

    var responseOutputBlock: OutputBlock? = nil

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }

        guard let notificationResponse = response as? UNTextInputNotificationResponse else {
            return
        }

        responseOutputBlock?(notificationResponse.userText)
    }

    /// Ensure notifications are presented even while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
