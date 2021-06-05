//
//  NotificationManager.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Gois on 04/06/21.
//

import Foundation
import UserNotifications

struct NotificationManager {

    // MARK: - Properties

    private static let center = UNUserNotificationCenter.current()

    // MARK: - Methods

    static func firstNotification(
        _ message: Message
    ) {
        let timer = Double(CommonData.shared.minutes * 60 + CommonData.shared.seconds)
        let repeats = false
        sendNotification(message, timer, repeats)
    }

    static func sendNotification(
        _ message: Message,
        _ timer: Double,
        _ repeats: Bool
        ) {
        guard !timer.isZero else { return }

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timer,
            repeats: repeats
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: createContent(message),
            trigger: trigger
        )

        center.add(request)
    }

    static func removeNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    static func requestAuthorization() {
        center.requestAuthorization(options: [.sound, .alert]) { _, _ in }
    }
}

// MARK: - Helpers

fileprivate extension NotificationManager {
    static func createContent(_ data: Message) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.message
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default

        return content
    }

    static func removeAllDelivered() {
        center.removeAllDeliveredNotifications()
    }
}

// MARK: - Structs

extension NotificationManager {
    struct Message {
        let title: String
        let message: String
    }
}
