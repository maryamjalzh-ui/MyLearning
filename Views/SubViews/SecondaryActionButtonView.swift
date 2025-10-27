import SwiftUI

// MARK: - SecondaryActionButtonView
// Represents the secondary button used to mark a day as "Freezed"
struct SecondaryActionButtonView: View {
    @ObservedObject var manager: ActivityManager   // Observes the user's learning activity data
    let maxFreezes: Int                            // Maximum number of freezes allowed for this goal

    // MARK: - Disable Logic
    // The button is disabled when:
    // 1. The day is already logged or freezed
    // 2. The user has used all available freezes
    var isDisabled: Bool {
        let status = manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default
        return status == .Logged || status == .Freezed || manager.currentGoalFreezed >= maxFreezes
    }

    var body: some View {
        Button(action: {
            // Only allow freezing if not disabled
            if !isDisabled {
                manager.updateStatus(to: .Freezed)
            }
        }) {
            // Button label and appearance
            Text("Log as Freezed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(Color.freezedCyan) // Cyan-colored capsule background
                )
        }
        .buttonStyle(.plain) // Remove default button effects
        .shadow(
            color: Color.cyan.opacity(0.4),
            radius: 40
        ) // Adds a soft cyan glow
        .disabled(isDisabled) // Disable if user cannot freeze
        .shadow(color: Color.cyan.opacity(0.5), radius: 10)
        // Glass-like transparent effect for styling
        .glassEffect(.clear.tint(.clear))
    }
}

// MARK: - Preview
#Preview {
    SecondaryActionButtonView(manager: ActivityManager(), maxFreezes: 2)
}
