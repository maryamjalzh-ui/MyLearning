import SwiftUI

struct SecondaryActionButtonView: View {
    @ObservedObject var manager: ActivityManager
    let maxFreezes: Int

    var isDisabled: Bool {
        let status = manager.dailyStatus[manager.selectedDate.startOfDay!] ?? .Default
        return status == .Logged || status == .Freezed || manager.currentGoalFreezed >= maxFreezes
    }

    var body: some View {
        Button(action: {
            if !isDisabled {
                manager.updateStatus(to: .Freezed)
            }
        }) {
            Text("Log as Freezed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.freezedCyan))
        }
        .buttonStyle(.plain)
        .shadow(color: Color.freezedCyan.opacity(0.4), radius: 40)
        .disabled(isDisabled)
    }
}

#Preview {
    SecondaryActionButtonView(manager: ActivityManager(), maxFreezes: 2)
}
