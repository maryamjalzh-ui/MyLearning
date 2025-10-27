import SwiftUI

struct LearningGoal: View {
    @EnvironmentObject var manager: ActivityManager
    @State private var learningTopic: String = ""
    @State private var selectedDuration: FirstPage.Duration = .week
    @State private var showConfirmation = false
    @State private var navigateToSecondPage = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 50) {
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

                    VStack(alignment: .leading, spacing: 15) {
                        Text("I want to learn it in a")
                            .font(.body)
                            .foregroundColor(.primary)

                        HStack(spacing: 10) {
                            ForEach(FirstPage.Duration.allCases, id: \.self) { duration in
                                DurationButton(duration: duration, selectedDuration: $selectedDuration)
                            }
                            Spacer()
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 30)
                .blur(radius: showConfirmation ? 3 : 0)

                // ✅ نافذة التأكيد
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

                        HStack(spacing: 16) {
                            Button(action: {
                                showConfirmation = false
                            }) {
                                Text("Dismiss")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: 132, maxHeight: 48)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.darkGreyBackground))
                            }

                            Button(action: {
                                manager.resetCountersForNewGoal()
                                showConfirmation = false
                                navigateToSecondPage = true
                            }) {
                                Text("Update")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: 132, maxHeight: 48)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentOrange))
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

                // ✅ الانتقال بعد التأكيد
                NavigationLink(
                    destination: SecondPage(
                        learningTopic: learningTopic,
                        selectedDuration: selectedDuration
                    ).environmentObject(manager),
                    isActive: $navigateToSecondPage
                ) { EmptyView() }
            }
            .accentColor(Color.accentOrange)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Learning Goal")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showConfirmation = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.accentOrange)
                                .frame(width: 35, height: 35)

                            Image(systemName: "checkmark")
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
        .environmentObject(ActivityManager())
}
