import SwiftUI

// MARK: - Duration Button Component
// This struct defines a reusable button for selecting a learning duration (Week, Month, or Year)
struct DurationButton: View {
    let duration: FirstPage.Duration              // The duration this button represents
    @Binding var selectedDuration: FirstPage.Duration // The currently selected duration (shared state)

    // Check if this button is the selected one
    var isSelected: Bool { duration == selectedDuration }

    var body: some View {
        Button(action: {
            // When tapped, update the selected duration
            selectedDuration = duration
        }) {
            // Button label
            Text(duration.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .primary : .secondary) // Highlight selected duration
                .padding(.horizontal, 20)
                .frame(height: 58)
                .glassEffect(.clear)
                .background(
                    Group {
                        if isSelected {
                            // Apply an orange capsule background only if selected
                            Capsule()
                                .fill(Color.accentOrange)
                        }
                    }
                    .frame(height: 58)
                )
        }
        .buttonStyle(.plain) // Removes default button styling
    }
}

// MARK: - Main View: FirstPage
// The first screen of the app where users enter what they want to learn and select duration
struct FirstPage: View {

    // Enum representing available learning durations
    enum Duration: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    @EnvironmentObject var activityManager: ActivityManager // Shared app data
    @State private var learningTopic: String = ""            // User input for learning topic
    @State private var selectedDuration: Duration = .week    // Default selected duration

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color that adapts to light/dark mode
                Color(.systemBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 50) {

                    // MARK: - Logo/Icon Section
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color(.secondarySystemBackground)) // Background circle
                                .shadow(color: Color.orange.opacity(0.3), radius: 5) // Soft shadow
                                .glassEffect(.clear)

                            Image(systemName: "flame.fill") // Fire icon symbolizing learning/streak
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

                    // MARK: - Greeting Header
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Hello Learner") // Main greeting
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("This app will help you learn everyday!") // Subtitle
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }

                    // MARK: - Learning Topic Input Field
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 0) {
                            // Decorative left line
                            Color(.tertiarySystemBackground)
                                .frame(width: 4, height: 20)
                                .cornerRadius(2)

                            // Label text
                            Text("I want to learn")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.leading, 12)
                        }

                        // Text field for entering learning topic
                        TextField("Enter topic (e.g., Swift)", text: $learningTopic)
                            .foregroundColor(.primary)
                            .accentColor(.accentOrange)
                            .padding(.vertical, 8)

                        Divider().background(Color.secondary) // Separator line
                    }

                    // MARK: - Duration Selection Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("I want to learn it in a")
                            .font(.body)
                            .foregroundColor(.primary)

                        HStack(spacing: 10) {
                            // Create a button for each duration option
                            ForEach(Duration.allCases, id: \.self) { duration in
                                DurationButton(duration: duration, selectedDuration: $selectedDuration)
                            }
                            Spacer()
                        }
                    }

                    Spacer()

                    // MARK: - Navigation Button
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: SecondPage(
                                learningTopic: learningTopic,
                                selectedDuration: selectedDuration
                            ).environmentObject(activityManager)
                        ) {
                            // Button label
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
            .accentColor(Color.accentOrange) // Global accent color
        }
    }
}

// MARK: - Preview
#Preview {
    FirstPage()
        .environmentObject(ActivityManager()) // Inject preview environment object
}
