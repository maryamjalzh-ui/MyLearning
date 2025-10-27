import SwiftUI

// MARK: - MainActionButton Component
// Represents the main circular action button to log the current day as "Learned"
struct MainActionButton: View {
    @ObservedObject var manager: ActivityManager   // Observes user's activity data and updates UI

    // MARK: - Displayed Button Text
    // Changes based on the current day's status
    var text: String {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return "Log as Learned"   // Default state (not yet logged)
        case .Logged:  return "Learned Today"    // Already logged as learned
        case .Freezed: return "Day Freezed"      // Day marked as freezed
        }
    }

    // MARK: - Text Color Based on Status
    var textColor: Color {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return .primaryText
        case .Logged:  return .accentOrange
        case .Freezed: return .freezedCyan
        }
    }

    // MARK: - Background Color Based on Status
    var bgColor: Color {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return .accentOrange
        case .Logged:  return Color.LoggedColor
        case .Freezed: return .FreezedColor
        }
    }

    // MARK: - Disable Button When Day Already Logged or Freezed
    var isDisabled: Bool {
        let status = manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default
        return status == .Logged || status == .Freezed
    }

    var body: some View {
        // Main circular button
        Button(action: { manager.updateStatus(to: .Logged) }) {
            Text(text)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(textColor)
                .frame(width: 250, height: 250)
                .background(
                    Circle()
                        .fill(bgColor)
                        // Soft glowing shadow for emphasis
                        .shadow(color: Color.orange.opacity(0.5), radius: 10)
                        // Glass-like transparent effect for styling
                        .glassEffect(.clear.tint(.buttonGlow))
                )
        }
        // Disable if already learned or freezed
        .disabled(isDisabled)
    }
}

// MARK: - Preview
#Preview {
    MainActionButton(manager: ActivityManager())
}
