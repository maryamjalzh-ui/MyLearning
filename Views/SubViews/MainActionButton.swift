import SwiftUI

struct MainActionButton: View {
    @ObservedObject var manager: ActivityManager
    
    var text: String {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return "Log as Learned"
        case .Logged: return "Learned Today"
        case .Freezed: return "Day Freezed"
        }
    }

    var textColor: Color {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return .primaryText
        case .Logged: return .accentOrange
        case .Freezed: return .freezedCyan
        }
    }

    var bgColor: Color {
        switch manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default {
        case .Default: return .accentOrange
        case .Logged: return Color.LoggedColor
        case .Freezed: return .FreezedColor
        }
    }

    var isDisabled: Bool {
        let status = manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default
        return status == .Logged || status == .Freezed
    }

    var body: some View {
        Button(action: { manager.updateStatus(to: .Logged) }) {
            Text(text)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(textColor)
                .frame(width: 250, height: 250)
                .background(
                    Circle()
                        .fill(bgColor)
                        .shadow(color: Color.orange.opacity(0.5), radius: 10)
                        .glassEffect(.clear.tint(.buttonGlow))
                )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    MainActionButton(manager: ActivityManager())
}
