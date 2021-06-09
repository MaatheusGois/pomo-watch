//
//  pomodoroApp.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Gois on 04/06/21.
//

import SwiftUI
import UserNotifications

@main
struct pomodoroApp: App {

    @StateObject var localNotificaitonCenter = LocalNotificaitonCenter()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                CountView()
                    .environmentObject(localNotificaitonCenter)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

// MARK: - LocalNotificaitonCenter

class LocalNotificaitonCenter: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound])
    }
}
