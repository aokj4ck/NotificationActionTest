//
//  ViewController.swift
//  NotificationActionTest
//
//  Created by Jack on 12/5/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Push Notification

    /// Send a push notification immediately using the category that supports text response actions
    @objc func schedulePush() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                        repeats: false)

        let content = UNMutableNotificationContent()
        content.categoryIdentifier = NotificationRegisterModel.Categories.main
        content.title = "NotificationActionTest"
        content.body = "Please respond!"
        content.sound = UNNotificationSound.default

        let localNotification = UNNotificationRequest(identifier: UUID().uuidString,
                                                      content: content,
                                                      trigger: trigger)

        UNUserNotificationCenter.current().add(localNotification, withCompletionHandler: { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        })
    }

    // MARK: Inputs

    /// Receive an user response from the notification model
    func display(response: String) {
        receivedResponseTextView.text = response
    }

    // MARK: Internal set-up

    private let responseLabel = UILabel()
    private let receivedResponseTextView = UITextView()
    private let sendPushButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        responseLabel.text = "Response:"

        receivedResponseTextView.isEditable = false
        receivedResponseTextView.backgroundColor = UIColor.secondarySystemBackground
        receivedResponseTextView.accessibilityIdentifier = "ReceivedResponseTextView"

        sendPushButton.setTitle("Schedule push", for: .normal)
        sendPushButton.setTitleColor(UIColor.darkText, for: .normal)

        [sendPushButton, responseLabel, receivedResponseTextView].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            responseLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            responseLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0),

            receivedResponseTextView.topAnchor.constraint(equalToSystemSpacingBelow: responseLabel.bottomAnchor, multiplier: 1.0),
            receivedResponseTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0),
            receivedResponseTextView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 1.0),
            receivedResponseTextView.bottomAnchor.constraint(equalToSystemSpacingBelow: sendPushButton.topAnchor, multiplier: 0.5),

            sendPushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendPushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        sendPushButton.addTarget(self, action: #selector(schedulePush), for: .touchUpInside)
    }

}

