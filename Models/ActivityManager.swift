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
// Represents the status of each learning day
enum ActivityStatus: Codable, Equatable {
    case Default   // No activity logged
    case Logged    // Day marked as learned
    case Freezed   // Day marked as freezed (paused)
}

// MARK: - ActivityManager
// Central class responsible for managing all learning activity data and progress tracking
class ActivityManager: ObservableObject {
    @Published var startOfWeek: Date               // The start date of the currently displayed week
    @Published var selectedDate: Date              // The currently selected date
    @Published var dailyStatus: [Date: ActivityStatus] // Dictionary mapping each date to its activity status
    
    // ✅ Goal-specific counters for the current learning goal
    @Published var currentGoalLearned = 0          // Number of days marked as "learned"
    @Published var currentGoalFreezed = 0          // Number of days marked as "freezed"

    // MARK: - Initializer
    init() {
        let today = Date().startOfDay!             // Get today's date (without time)
        let weekStart = today.startOfWeek!         // Determine the start of the current week
        self.startOfWeek = weekStart
        self.selectedDate = today
        self.dailyStatus = [:]                     // Initialize with no activity data
    }

    // MARK: - Computed Properties
    // Total number of learned days (from all history)
    var daysLearned: Int { dailyStatus.values.filter { $0 == .Logged }.count }
    // Total number of freezed days (from all history)
    var daysFreezed: Int { dailyStatus.values.filter { $0 == .Freezed }.count }

    // MARK: - Update Daily Status
    // Updates the activity status for the selected date
    func updateStatus(to status: ActivityStatus) {
        dailyStatus[selectedDate.startOfDay!] = status

        // Increment the counters based on status
        switch status {
        case .Logged:
            currentGoalLearned += 1
        case .Freezed:
            currentGoalFreezed += 1
        default:
            break
        }
    }
    
    // MARK: - Reset Counters
    // Resets goal-specific counters (used when starting a new goal)
    func resetCountersForNewGoal() {
        currentGoalLearned = 0
        currentGoalFreezed = 0
    }
}


