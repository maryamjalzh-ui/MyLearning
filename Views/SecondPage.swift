import SwiftUI

struct SecondPage: View {
    @EnvironmentObject var manager: ActivityManager  // Shared object managing user activity data
    var learningTopic: String                        // Topic user chose to learn
    var selectedDuration: FirstPage.Duration          // Duration (week, month, year) user selected

    // ✅ Calculate the number of days based on selected goal duration
    private var goalDays: Int {
        switch selectedDuration {
        case .week:  return 7
        case .month: return 30
        case .year:  return 365
        }
    }

    // ✅ Check if the user has completed their goal (learned + freezed days)
    private var isGoalDone: Bool {
        let totalLogged = manager.currentGoalLearned      // Total days learned
        let totalFreezed = manager.currentGoalFreezed     // Total days freezed (paused)
        let totalDays = totalLogged + totalFreezed        // Combined progress
        return totalDays >= goalDays                      // Goal considered done if total ≥ target
    }

    // Maximum number of freezes allowed depending on duration
    var maxFreezes: Int {
        switch selectedDuration {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }

    var body: some View {
        ZStack {
            // App background color that adapts to light/dark mode
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 25) {
                // ✅ Main progress card
                VStack(spacing: 20) {
                    // Weekly progress calendar view
                    WeekCalendarView(manager: manager)
                    
                    // Display selected learning topic
                    Text(learningTopic)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    
                    // ✅ Goal progress summary cards (Learned & Freezed)
                    HStack(spacing: 10) {
                        SummaryCard(
                            value: manager.currentGoalLearned,           // Learned days count
                            label: "Days Learned",
                            color: Color.accentOrange.opacity(0.8),
                            icon: "flame.fill",
                            iconColor: .accentOrange
                        )
                        SummaryCard(
                            value: manager.currentGoalFreezed,           // Freezed days count
                            label: "Days Freezed",
                            color: Color.freezedCyan.opacity(0.7),
                            icon: "cube.fill",
                            iconColor: .freezedCyan
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.darkGreyBackground.opacity(0.5))     // Semi-transparent background
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray, lineWidth: 0.3)              // Subtle border line
                )

                // ✅ If goal is completed, show the congratulation view
                if isGoalDone {
                    VStack(spacing: 20) {
                        Image(systemName: "hands.clap.fill")             // Celebration icon
                            .font(.system(size: 50))
                            .foregroundColor(.accentOrange)
                            .padding(.top, 30)

                        Text("Well done!")                               // Congratulation header
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)

                        Text("Goal completed! Start learning again or set a new learning goal.")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondaryText)
                            .padding(.horizontal, 20)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity)


                        // Button to set a new learning goal
                        NavigationLink(destination: LearningGoal().environmentObject(manager)) {
                            Text("Set new learning goal")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 280, height: 50)
                                .glassEffect(.clear)
                                .background(Color.accentOrange)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        // Button to restart same goal and duration
                        Button(action: {
                            manager.resetCountersForNewGoal()
                        }) {
                            Text("Set same learning goal and duration")
                                .font(.footnote)
                                .foregroundColor(.accentOrange)
                        }
                        .padding(.bottom, 40)
                    }
                    .transition(.opacity)
                } else {
                    // ✅ Default view while still learning
                    MainActionButton(manager: manager)                   // Main button (e.g., Log learning)
                    SecondaryActionButtonView(manager: manager, maxFreezes: maxFreezes) // Secondary action (freeze)
                    
                    // Show number of freezes used out of total allowed
                    Text("\(manager.currentGoalFreezed) out of \(maxFreezes) Freezes used")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
        }
        .tint(.accentOrange) // Global accent color for buttons and highlights
        .toolbar {
            // Toolbar title in the center
            ToolbarItem(placement: .principal) {
                Text("Activity")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
            }

            // Toolbar buttons on the top right corner
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 15) {
                    // Navigate to AllActivity view
                    NavigationLink(destination: AllActivity().environmentObject(manager)) {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .padding(4)
                    }

                    // Navigate to LearningGoal setup screen
                    NavigationLink(destination: LearningGoal().environmentObject(manager)) {
                        Image(systemName: "pencil.and.outline")
                            .font(.title2)
                            .padding(4)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SecondPage(learningTopic: "Swift", selectedDuration: .week)
            .environmentObject(ActivityManager()) // Inject ActivityManager for preview
    }
}
