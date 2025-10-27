import SwiftUI

// === 1. Calendar Helpers ===
extension Calendar {
    // Generate all days for a given month, aligned to a full 6x7 grid (42 cells total)
    func generateDaysInMonthAligned(for date: Date) -> [Date] {
        guard let monthInterval = self.dateInterval(of: .month, for: date) else { return [] }

        let firstOfMonth = monthInterval.start
        let range = self.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        // Weekday of the first day in the month (1 = Sunday)
        let weekdayOfFirst = self.component(.weekday, from: firstOfMonth)

        var dates: [Date] = []

        // Add placeholder dates before the first day (for alignment)
        for _ in 1..<weekdayOfFirst {
            dates.append(Date.distantPast)
        }

        // Add actual days of the month
        for day in 0..<numDays {
            if let date = self.date(byAdding: .day, value: day, to: firstOfMonth) {
                dates.append(date)
            }
        }

        // Fill remaining cells until reaching 42 items (6 weeks)
        while dates.count % 7 != 0 || dates.count < 42 {
            dates.append(Date.distantFuture)
        }

        return dates
    }
}

// === 2. WeekHeaderView (Displays 3-letter weekday names) ===
struct WeekHeaderView: View {
    @Environment(\.calendar) var calendar

    var body: some View {
        HStack {
            ForEach(0..<7) { index in
                // Get short weekday symbol (e.g., Mon, Tue, Wed)
                let symbol = calendar.shortWeekdaySymbols[(index + calendar.firstWeekday - 1) % 7]
                Text(symbol)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

// === 3. DayCell (Displays individual days with color based on status) ===
struct DayCell: View {
    let date: Date
    let calendar: Calendar
    let isCurrentMonth: Bool
    @EnvironmentObject var manager: ActivityManager

    // Check if the date is today
    var isToday: Bool { calendar.isDateInToday(date) }

    // Retrieve the status (Logged, Freezed, or Default) from ActivityManager
    var status: ActivityStatus { manager.dailyStatus[date.startOfDay!] ?? .Default }

    var body: some View {
        VStack {
            // Only render valid dates, not placeholders
            if date > Date.distantPast && date < Date.distantFuture {
                Text(String(calendar.component(.day, from: date))) // Display day number
                    .font(.body)
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundColor(isCurrentMonth ? (isToday ? .white : .primary) : .secondary)
                    .frame(width: 35, height: 35)
                    .background {
                        // Apply different circle colors based on daily status
                        switch status {
                        case .Logged:
                            Circle().fill(Color.orange.opacity(0.7))
                        case .Freezed:
                            Circle().fill(Color.cyan.opacity(0.7))
                        case .Default:
                            if isToday {
                                Circle().fill(Color.orange)
                            } else {
                                Color.clear
                            }
                        }
                    }
            } else {
                // Placeholder for alignment
                Text("").frame(width: 35, height: 35)
            }
        }
    }
}

// === 4. MonthView ===
struct MonthView: View {
    @Environment(\.calendar) var calendar
    let month: Date

    // Format the month title (e.g., "October 2025")
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    var body: some View {
        VStack(spacing: 15) {
            // Month title
            Text(dateFormatter.string(from: month).capitalized)
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            // Weekday header (Mon, Tue, etc.)
            WeekHeaderView()

            // Grid of all days in the month
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(calendar.generateDaysInMonthAligned(for: month), id: \.self) { date in
                    DayCell(
                        date: date,
                        calendar: calendar,
                        isCurrentMonth: calendar.isDate(date, equalTo: month, toGranularity: .month)
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

// === 5. FullScreenCalendarView ===
struct FullScreenCalendarView: View {
    @Environment(\.calendar) var calendar
    let monthsRange = -0...12 // Number of months to display (current + next 12)

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 25) {
                    // Create a MonthView for each month in range
                    ForEach(monthsRange, id: \.self) { offset in
                        if let month = calendar.date(byAdding: .month, value: offset, to: Date()) {
                            MonthView(month: month)
                                .id(month)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .onAppear {
                // Automatically scroll to the current month on appear
                if let todayMonth = calendar.date(byAdding: .month, value: 0, to: Date()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(todayMonth, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}

// === 6. Main AllActivity View ===
struct AllActivity: View {
    @EnvironmentObject var manager: ActivityManager

    var body: some View {
        NavigationView {
            FullScreenCalendarView()
                .navigationTitle("All Activities")         // Set navigation bar title
                .navigationBarTitleDisplayMode(.inline)    // Keep title centered and compact
        }
    }
}

// === 7. Preview ===
#Preview {
    let previewManager = ActivityManager()
    // Example statuses for preview
    previewManager.dailyStatus[Date().startOfDay!] = .Logged
    previewManager.dailyStatus[
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!.startOfDay!
    ] = .Freezed

    return AllActivity()
        .environmentObject(previewManager) // Inject manager for SwiftUI preview
}
