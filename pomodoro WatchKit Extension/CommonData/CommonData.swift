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

    @UserDefaultAccess(key: "minutes", defaultValue: Default.minutes)
    public var minutes: Int

    @UserDefaultAccess(key: "seconds", defaultValue: Default.seconds)
    public var seconds: Int

    @UserDefaultAccess(key: "part", defaultValue: Default.part)
    public var part: Int

    @UserDefaultAccess(key: "full", defaultValue: Default.full)
    public var full: Int

    @UserDefaultAccess(key: "times", defaultValue: Default.times)
    public var times: Int

    @UserDefaultAccess(key: "workTime", defaultValue: Default.workTime)
    public var workTime: Bool

    @UserDefaultAccess(key: "isRunning", defaultValue: Default.isRunning)
    public var isRunning: Bool
}

// MARK: - Default

extension CommonData {
    enum Default {
        static let minutes: Int = 1
        static let seconds: Int = 0

        static let part: Int = 1
        static let full: Int = 4
        static let times: Int = 1

        static let workTime: Bool = true
        static let isRunning: Bool = false
    }
}
