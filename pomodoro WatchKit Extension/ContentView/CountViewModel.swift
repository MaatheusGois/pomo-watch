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

    @Published private(set) var isWorking: Bool = CommonData.shared.isWorking {
        willSet {
            CommonData.shared.isWorking = newValue
        }
    }

    @Published public var isRunning: Bool = CommonData.shared.isRunning {
        willSet {
            CommonData.shared.isRunning = newValue
            if newValue {
                let remain = CommonData.shared.minutes.double * Constants.Values.timer + CommonData.shared.seconds.double
                CommonData.shared.nextDate = Date().addingTimeInterval(remain)
                CommonData.shared.isInitialWorkState = isWorking
                NotificationManager.sheduleNotifications()
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
        isWorking ? Constants.Values.workMinutes : Constants.Values.freeMinutes
    }

    // MARK: - Methods

    open func incrementTimer() {
        guard isRunning else { return }
        if seconds.isZero {
            if minutes.isZero {
                isWorking.toggle()
                haptic()    
                minutes = newTime

                if isWorking {
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

    open func calculatePassedTime() {
        guard CommonData.shared.isRunning else { return }
        let nextDate = CommonData.shared.nextDate
        let workTime = CommonData.Default.workMinutes.double * Constants.Values.timer
        let breakTime = CommonData.Default.freeMinutes.double * Constants.Values.timer

        var isWorking = CommonData.shared.isInitialWorkState
        let finalDate = Date()

        var date = nextDate
        var count = 1

        while date <= finalDate {
            if isWorking {
                date.addTimeInterval(breakTime)
                count.increment()
            } else {
                date.addTimeInterval(workTime)
            }
            isWorking.toggle()
        }

        let interval = finalDate.distance(to: date)
        let seconds = interval.truncatingRemainder(dividingBy: Constants.Values.timer).int
        let minutes = (interval / Constants.Values.timer).truncatingRemainder(dividingBy: Constants.Values.timer)

        let truncated = count.double.truncatingRemainder(dividingBy: full.double)
        let countValue = truncated == .zero ? truncated + 1 : truncated

        self.isWorking = isWorking
        self.minutes = minutes.int
        self.seconds = seconds
        self.part = countValue.int
        self.times = count / full + 1
    }

    open func reset() {
        minutes = CommonData.Default.workMinutes
        seconds = CommonData.Default.seconds
        part = CommonData.Default.part
        full = CommonData.Default.full
        times = CommonData.Default.times
        isRunning = CommonData.Default.isRunning
        isWorking = CommonData.Default.isWorking
    }
}

// MARK: - Extensions

fileprivate extension CountViewModel {
    func haptic() {
        let type: WKHapticType = isWorking ? .success : .retry
        WKInterfaceDevice.current().play(type)
    }
}

// MARK: - Constants

fileprivate extension CountViewModel {
    enum Constants {
        enum Values {
            static let workMinutes: Int = CommonData.Default.workMinutes - 1
            static let freeMinutes: Int = CommonData.Default.freeMinutes - 1
            static let secondsFull: Int = 59

            static let timerPublish: Double = 1
            static let timer: Double = 60
        }
    }
}
