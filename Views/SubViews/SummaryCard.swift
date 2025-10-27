import SwiftUI

struct SummaryCard: View {
    let value: Int
    let label: String
    let color: Color
    let icon: String
    let iconColor: Color

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
                Text(label)
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
    SummaryCard(value: 5, label: "Days Learned", color: .orange, icon: "flame.fill", iconColor: .accentOrange)
}
