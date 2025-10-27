import SwiftUI

struct DateButton: View {
    @ObservedObject var manager: ActivityManager
    let date: Date
    
    var status: ActivityStatus { manager.dailyStatus[date.startOfDay!] ?? .Default }
    var isSelected: Bool { manager.selectedDate.startOfDay! == date.startOfDay! }
    let isPastDay: Bool
    
    init(manager: ActivityManager, date: Date) {
        self.manager = manager
        self.date = date
        self.isPastDay = date < Date().startOfDay!
    }

    var body: some View {
        Button(action: {
            if !isPastDay {
                manager.selectedDate = date.startOfDay!
            }
        }) {
            VStack(spacing: 10) {
                Text(date.dayAbbreviation)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isPastDay ? .gray.opacity(0.4) : .secondaryText)
                
                Text("\(date.dayNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isPastDay ? .gray.opacity(0.5) : .primaryText)
                    .frame(width: 50, height: 40)
                    .background(
                        Group {
                            if isSelected && !isPastDay {
                                Circle().fill(Color.orange.opacity(0.90))
                            } else if status == .Logged {
                                Circle().fill(Color.accentOrange.opacity(0.3))
                            } else if status == .Freezed {
                                Circle().fill(Color.freezedCyan.opacity(0.3))
                            } else {
                                Color.clear
                            }
                        }
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(isPastDay)
    }
}

#Preview {
    DateButton(manager: ActivityManager(), date: Date())
}
