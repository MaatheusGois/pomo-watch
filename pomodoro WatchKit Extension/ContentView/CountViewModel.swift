//
//  ContentViewModel.swift
//  pomodoro
//
//  Created by Matheus Gois on 05/06/21.
//

import SwiftUI

// MARK: - Class

class CountViewModel: ObservableObject {

    // MARK: - Properties

    // Publish
    @Published private(set) var minutes: Int = CommonData.shared.minutes {
        willSet {
            CommonData.shared.minutes = newValue
        }
    }

    @Published private(set) var seconds: Int = CommonData.shared.seconds {
        willSet {
            CommonData.shared.seconds = newValue
        }
    }

    @Published private(set) var part: Int = CommonData.shared.part {
        willSet {
            CommonData.shared.part = newValue
        }
    }

    @Published private(set) var full: Int = CommonData.shared.full {
        willSet {
            CommonData.shared.full = newValue
        }
    }

    @Published private(set) var times: Int = CommonData.shared.times {
        willSet {
            CommonData.shared.times = newValue
        }
    }

    @Published private(set) var workTime: Bool = CommonData.shared.workTime {
        willSet {
            CommonData.shared.workTime = newValue
        }
    }

    @Published public var isRunning: Bool = CommonData.shared.isRunning {
        willSet {
            CommonData.shared.isRunning = newValue
            if newValue {
                NotificationManager.firstNotification(alertMessage)
            } else {
                NotificationManager.removeNotifications()
            }
        }
    }

    // Open
    open var timer = Timer.publish(every: Constants.Values.timerPublish, on: .main, in: .common).autoconnect()
    open var timerTitle: String { "\(minutes.inTime):\(seconds.inTime)" }
    open var buttonTitle: String { isRunning ? "Stop" : "Start" }
    open var countTitle: String { "\(part)/\(full)" }

    // Private
    private var newTime: Int {
        workTime ? Constants.Values.workMinutes : Constants.Values.freeMinutes
    }

    private var alertMessage: NotificationManager.Message {
        .init(
            title: !workTime ? "Work" : "Break",
            message: !workTime ? "Go back to work" : "Take a minute to relax"
        )
    }

    // MARK: - Methods

    open func incrementTimer() {
        guard isRunning else { return }
        if seconds.isZero {
            if minutes.isZero {
                workTime.toggle()
                haptic()    
                minutes = newTime

                if workTime {
                    part.increment()
                }

                if part > full {
                    part = CommonData.Default.part
                    times.increment()
                }
            } else {
                minutes.decrement()
            }
            seconds = Constants.Values.secondsFull
        } else {
            seconds.decrement()
        }
    }

    open func reset() {
        minutes = CommonData.Default.minutes
        seconds = CommonData.Default.seconds
        part = CommonData.Default.part
        full = CommonData.Default.full
        times = CommonData.Default.times
        isRunning = CommonData.Default.isRunning
        workTime = CommonData.Default.workTime
    }
}

// MARK: - Extensions

fileprivate extension CountViewModel {
    func haptic() {
        let type: WKHapticType = workTime ? .success : .retry
        WKInterfaceDevice.current().play(type)
    }
}

// MARK: - Constants

fileprivate extension CountViewModel {
    enum Constants {
        enum Values {
            static let workMinutes: Int = 0
            static let freeMinutes: Int = 0
            static let secondsFull: Int = 5 // 59

            static let timerPublish: Double = 1
        }
    }
}
