//
//  pomodoroApp.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Silva on 04/06/21.
//

import SwiftUI

@main
struct pomodoroApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
