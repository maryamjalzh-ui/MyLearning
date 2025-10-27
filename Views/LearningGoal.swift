import SwiftUI

struct LearningGoal: View {
    @EnvironmentObject var manager: ActivityManager     // Shared activity manager across views
    @State private var learningTopic: String = ""       // Stores the topic user wants to learn
    @State private var selectedDuration: FirstPage.Duration = .week // Selected duration (default: week)
    @State private var showConfirmation = false          // Controls visibility of confirmation popup
    @State private var navigateToSecondPage = false      // Triggers navigation after confirmation

    var body: some View {
        NavigationStack {
            ZStack {
                // App background color that adapts to light/dark mode
                Color(.systemBackground).ignoresSafeArea()

                // MARK: - Main Content
                VStack(alignment: .leading, spacing: 50) {
                    
                    // Input for learning topic
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 0) {
                            // Decorative side bar
                            Color(.tertiarySystemBackground)
                                .frame(width: 4, height: 20)
                                .cornerRadius(2)
                            
                            Text("I want to learn")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.leading, 12)
                        }

                        // TextField for topic input
                        TextField("Enter topic (e.g., Swift)", text: $learningTopic)
                            .foregroundColor(.primary)
                            .accentColor(.accentOrange)
                            .padding(.vertical, 8)

                        Divider().background(Color.secondary)
                    }

                    // Duration selection buttons
                    VStack(alignment: .leading, spacing: 15) {
                        Text("I want to learn it in a")
                            .font(.body)
                            .foregroundColor(.primary)

                        HStack(spacing: 10) {
                            // Generate a button for each available duration
                            ForEach(FirstPage.Duration.allCases, id: \.self) { duration in
                                DurationButton(duration: duration, selectedDuration: $selectedDuration)
                            }
                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 30)
                // Apply blur effect when confirmation popup is shown
                .blur(radius: showConfirmation ? 3 : 0)

                // MARK: - Confirmation Popup
                if showConfirmation {
                    VStack(spacing: 16) {
                        Text("Update Learning goal")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryText)

                        Text("If you update now, your streak will start over.")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        // Buttons inside confirmation window
                        HStack(spacing: 16) {
                            // Dismiss button — cancels update
                            Button(action: {
                                showConfirmation = false
                            }) {
                                Text("Dismiss")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: 132, maxHeight: 48)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.darkGreyBackground)
                                    )
                            }

                            // Update button — resets progress and navigates to new goal
                            Button(action: {
                                manager.resetCountersForNewGoal()   // Reset all counters
                                showConfirmation = false
                                navigateToSecondPage = true         // Trigger navigation
                            }) {
                                Text("Update")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: 132, maxHeight: 48)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.accentOrange)
                                    )
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 300, maxHeight: 184)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.darkGreyBackground.opacity(0.3))
                    )
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .transition(.scale)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray, lineWidth: 0.3)
                    )
                }

                // MARK: - Navigation Trigger
                NavigationLink(
                    destination: SecondPage(
                        learningTopic: learningTopic,
                        selectedDuration: selectedDuration
                    ).environmentObject(manager),
                    isActive: $navigateToSecondPage
                ) { EmptyView() }
            }
            .accentColor(Color.accentOrange)

            // MARK: - Toolbar Configuration
            .toolbar {
                // Center title in the navigation bar
                ToolbarItem(placement: .principal) {
                    Text("Learning Goal")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                // Confirmation button on top right corner
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showConfirmation = true                  // Show confirmation popup
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.accentOrange)
                                .frame(width: 35, height: 35)

                            Image(systemName: "checkmark")        // Checkmark icon
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    LearningGoal()
        .environmentObject(ActivityManager()) // Inject ActivityManager for preview mode
}
