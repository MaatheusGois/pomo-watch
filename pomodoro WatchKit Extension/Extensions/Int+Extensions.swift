//
//  Int+Extensions.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Gois on 05/06/21.
//

import Foundation

extension Int {

    // MARK: - Properties

    var isZero: Bool { self == .zero }
    var inTime: String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    var double: Double { Double(self) }

    // MARK: - Methods

    mutating func increment() { self += 1 }
    mutating func decrement() { self -= 1 }
}
