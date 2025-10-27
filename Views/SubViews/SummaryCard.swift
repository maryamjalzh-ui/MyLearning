import SwiftUI

struct SummaryCard: View {
    let value: Int
    let label: String
    let color: Color
    let icon: String
    let iconColor: Color

    // MARK: - Dynamic plural logic
    // If the number is 1, use "Day" instead of "Days"
    var pluralLabel: String {
        if value == 1 {
            return label.replacingOccurrences(of: "Days", with: "Day")
        } else {
            return label
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .padding(.leading, 5)
                .foregroundColor(iconColor)
            
            VStack(alignment: .leading) {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                // Use pluralLabel instead of plain label
                Text(pluralLabel)
                    .font(.caption)
                    .foregroundColor(.primaryText)
            }
            Spacer()
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 2)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 45).fill(color.opacity(0.4)))
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 15) {
        SummaryCard(value: 1, label: "Days Learned", color: .orange, icon: "flame.fill", iconColor: .accentOrange)
        SummaryCard(value: 3, label: "Days Freezed", color: .cyan, icon: "cube.fill", iconColor: .freezedCyan)
    }
}
