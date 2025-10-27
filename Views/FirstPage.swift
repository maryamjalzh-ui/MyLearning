import SwiftUI

// MARK: - Duration Button Component
struct DurationButton: View {
    let duration: FirstPage.Duration
    @Binding var selectedDuration: FirstPage.Duration

    var isSelected: Bool { duration == selectedDuration }

    var body: some View {
        Button(action: {
            selectedDuration = duration
        }) {
            Text(duration.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.horizontal, 20)
                .frame(height: 58)
                .glassEffect(.clear)
                .background(
                    Group {
                        if isSelected {
                            Capsule()
                                .fill(Color.accentOrange)
                        }
                    }
                    .frame(height: 58)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main View: FirstPage
struct FirstPage: View {

    enum Duration: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    @EnvironmentObject var activityManager: ActivityManager
    @State private var learningTopic: String = ""
    @State private var selectedDuration: Duration = .week

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 50) {

                    // Logo/Icon
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color(.secondarySystemBackground))
                                .shadow(color: Color.orange.opacity(0.3), radius: 5)
                                .glassEffect(.clear)

                            Image(systemName: "flame.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.accentOrange)
                        }
                        .frame(width: 109, height: 109)
                        .background(Color(.systemBackground))
                        .padding(.top)
                        Spacer()
                    }

                    // Header Text
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Hello Learner")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("This app will help you learn everyday!")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }

                    // Learning Topic Input
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 0) {
                            Color(.tertiarySystemBackground)
                                .frame(width: 4, height: 20)
                                .cornerRadius(2)

                            Text("I want to learn")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.leading, 12)
                        }

                        TextField("Enter topic (e.g., Swift)", text: $learningTopic)
                            .foregroundColor(.primary)
                            .accentColor(.accentOrange)
                            .padding(.vertical, 8)

                        Divider().background(Color.secondary)
                    }

                    // Duration Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("I want to learn it in a")
                            .font(.body)
                            .foregroundColor(.primary)

                        HStack(spacing: 10) {
                            ForEach(Duration.allCases, id: \.self) { duration in
                                DurationButton(duration: duration, selectedDuration: $selectedDuration)
                            }
                            Spacer()
                        }
                    }

                    Spacer()

                    // Start Learning Button
                    HStack {
                        Spacer()
                        NavigationLink(destination: SecondPage(
                            learningTopic: learningTopic,
                            selectedDuration: selectedDuration
                        ).environmentObject(activityManager)) {
                            Text("Start learning")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 250, height: 48)
                                .glassEffect(.clear)
                                .background(Color.accentOrange)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 30)
            }
            .accentColor(Color.accentOrange)
        }
    }
}

// MARK: - Preview
#Preview {
    FirstPage()
        .environmentObject(ActivityManager())
}
