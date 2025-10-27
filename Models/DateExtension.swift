//
//  DateExtension.swift
//  LearningApp_MVVM
//
//  Created by Maryam Jalal Alzahrani on 06/05/1447 AH.
//
// MARK: - Date Extensions
// Helper extensions to simplify date calculations and formatting
import Foundation

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
