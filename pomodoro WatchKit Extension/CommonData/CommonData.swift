//
//  CommonData.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Gois on 05/06/21.
//

import Foundation

final class CommonData {

    private init() {}
    static let shared = CommonData()

    @UserDefaultAccess(key: "minutes", defaultValue: Default.workMinutes)
    public var minutes: Int

    @UserDefaultAccess(key: "seconds", defaultValue: Default.seconds)
    public var seconds: Int

    @UserDefaultAccess(key: "part", defaultValue: Default.part)
    public var part: Int

    @UserDefaultAccess(key: "full", defaultValue: Default.full)
    public var full: Int

    @UserDefaultAccess(key: "times", defaultValue: Default.times)
    public var times: Int

    @UserDefaultAccess(key: "isWorking", defaultValue: Default.isWorking)
    public var isWorking: Bool

    @UserDefaultAccess(key: "isRunning", defaultValue: Default.isRunning)
    public var isRunning: Bool

    @UserDefaultAccess(key: "nextDate", defaultValue: Default.nextDate)
    public var nextDate: Date

    @UserDefaultAccess(key: "isInitialWorkState", defaultValue: Default.isWorking)
    public var isInitialWorkState: Bool
}

// MARK: - Default

extension CommonData {
    enum Default {
        static let workMinutes: Int = 25
        static let freeMinutes: Int = 5
        static let seconds: Int = 0

        static let part: Int = 1
        static let full: Int = 4
        static let times: Int = 1

        static let isWorking: Bool = true
        static let isRunning: Bool = false

        static let nextDate: Date = .init()
    }
}
