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

    static func sheduleNotifications() {
        let quantity = 10
        removeNotifications()
        removeAllDelivered()
        for i in .zero..<quantity {
            let remain = CommonData.shared.minutes.double * 60 + CommonData.shared.seconds.double

            let workMinutes = CommonData.Default.workMinutes.double * 60
            let freeMinutes = CommonData.Default.freeMinutes.double * 60

            let isWorking = CommonData.shared.isWorking
            let n = i.double

            let breakTime = remain + n * workMinutes + (n + (isWorking ? 0 : 1)) * freeMinutes
            let workTime = remain + n * workMinutes + (n + (isWorking ? 1 : 0)) * freeMinutes

            sheduleNotification(
                message: .init(type: .break),
                timer: breakTime,
                repeats: false
            )

            sheduleNotification(
                message: .init(type: .work),
                timer: workTime,
                repeats: false
            )
        }
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
    static func sheduleNotification(
        message: Message,
        timer: Double,
        repeats: Bool
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

// MARK: - Enums

extension NotificationManager {
    enum TypeMessage {
        case work
        case `break`
    }
}

// MARK: - Structs

extension NotificationManager {
    struct Message {
        let title: String
        let message: String

        init(type: TypeMessage) {
            title = type == .work ? "Work" : "Break"
            message = type == .work ? "Go back to work" : "Take a minute to relax"
        }
    }
}
