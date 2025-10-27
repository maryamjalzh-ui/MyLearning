//
//  ActivityManager.swift
//  LearningApp_MVVM
//
//  Created by Maryam Jalal Alzahrani on 05/05/1447 AH.
//

import Foundation
import SwiftUI
import Combine

// MARK: - App State
enum ActivityStatus: Codable, Equatable {
    case Default
    case Logged
    case Freezed
}

class ActivityManager: ObservableObject {
    @Published var startOfWeek: Date
    @Published var selectedDate: Date
    @Published var dailyStatus: [Date: ActivityStatus]
    
    // ✅ عدادات الهدف الحالي فقط
    @Published var currentGoalLearned = 0
    @Published var currentGoalFreezed = 0

    init() {
        let today = Date().startOfDay!
        let weekStart = today.startOfWeek!
        self.startOfWeek = weekStart
        self.selectedDate = today
        self.dailyStatus = [:]
    }

    var daysLearned: Int { dailyStatus.values.filter { $0 == .Logged }.count }
    var daysFreezed: Int { dailyStatus.values.filter { $0 == .Freezed }.count }

    func updateStatus(to status: ActivityStatus) {
        dailyStatus[selectedDate.startOfDay!] = status

        switch status {
        case .Logged:
            currentGoalLearned += 1
        case .Freezed:
            currentGoalFreezed += 1
        default:
            break
        }
    }
    
    func resetCountersForNewGoal() {
        currentGoalLearned = 0
        currentGoalFreezed = 0
    }
}

// MARK: - Date Extensions
extension Date {
    static let calendar = Calendar.current
    var startOfWeek: Date? {
        Date.calendar.date(from: Date.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    var startOfDay: Date? { Date.calendar.startOfDay(for: self) }
    var dayBefore: Date? { Date.calendar.date(byAdding: .day, value: -1, to: self) }
    var dayAfter: Date? { Date.calendar.date(byAdding: .day, value: 1, to: self) }
    var dayAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self).uppercased()
    }
    var dayNumber: Int { Date.calendar.component(.day, from: self) }
}
