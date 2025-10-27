import SwiftUI

// MARK: - DateButton Component
// Represents a selectable button for a specific date in the week view
struct DateButton: View {
    @ObservedObject var manager: ActivityManager // Observes activity data (status and selection)
    let date: Date                               // The specific date this button represents
    
    // Retrieve the activity status for the date (Logged, Freezed, Default)
    var status: ActivityStatus { manager.dailyStatus[date.startOfDay!] ?? .Default }
    
    // Check if this date is currently selected in the ActivityManager
    var isSelected: Bool { manager.selectedDate.startOfDay! == date.startOfDay! }
    
    // Determines if this date is in the past (before today)
    let isPastDay: Bool
    
    // Custom initializer to calculate isPastDay once
    init(manager: ActivityManager, date: Date) {
        self.manager = manager
        self.date = date
        self.isPastDay = date < Date().startOfDay!
    }

    var body: some View {
        Button(action: {
            // Only allow selecting dates that are today or in the future
            if !isPastDay {
                manager.selectedDate = date.startOfDay!
            }
        }) {
            VStack(spacing: 10) {
                // Display day abbreviation (e.g., Mon, Tue)
                Text(date.dayAbbreviation)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isPastDay ? .gray.opacity(0.4) : .secondaryText)
                
                // Display day number (e.g., 21)
                Text("\(date.dayNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isPastDay ? .gray.opacity(0.5) : .primaryText)
                    .frame(width: 50, height: 40)
                    .background(
                        Group {
                            // Highlight currently selected date
                            if isSelected && !isPastDay {
                                Circle().fill(Color.orange.opacity(0.90))
                            }
                            // Logged (learned) day indicator
                            else if status == .Logged {
                                Circle().fill(Color.accentOrange.opacity(0.3))
                            }
                            // Freezed (paused) day indicator
                            else if status == .Freezed {
                                Circle().fill(Color.freezedCyan.opacity(0.3))
                            }
                            // Default (no activity)
                            else {
                                Color.clear
                            }
                        }
                    )
            }
        }
        .buttonStyle(.plain) // Remove default button style (no blue highlight)
        .disabled(isPastDay) // Disable interaction for past days
    }
}

// MARK: - Preview
#Preview {
    DateButton(manager: ActivityManager(), date: Date())
}
