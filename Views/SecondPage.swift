import SwiftUI

struct SecondPage: View {
    @EnvironmentObject var manager: ActivityManager
    var learningTopic: String
    var selectedDuration: FirstPage.Duration

    // ✅ عدد الأيام المطلوبة بناءً على نوع الهدف
    private var goalDays: Int {
        switch selectedDuration {
        case .week:  return 7
        case .month: return 30
        case .year:  return 365
        }
    }

    // ✅ يتحقق إذا المستخدم خلص الهدف (تعلم + تجميد)
    private var isGoalDone: Bool {
        let totalLogged = manager.currentGoalLearned
        let totalFreezed = manager.currentGoalFreezed
        let totalDays = totalLogged + totalFreezed
        return totalDays >= goalDays
    }

    var maxFreezes: Int {
        switch selectedDuration {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 25) {
                // ✅ الكارد الأساسي
                VStack(spacing: 20) {
                    WeekCalendarView(manager: manager)
                    
                    Text(learningTopic)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    
                    // ✅ عدادات الهدف الحالي
                    HStack(spacing: 10) {
                        SummaryCard(
                            value: manager.currentGoalLearned,
                            label: "Days Learned",
                            color: Color.accentOrange.opacity(0.8),
                            icon: "flame.fill",
                            iconColor: .accentOrange
                        )
                        SummaryCard(
                            value: manager.currentGoalFreezed,
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
                        .fill(Color.darkGreyBackground.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray, lineWidth: 0.3)
                )

                // ✅ إذا خلص الهدف تطلع شاشة التهنئة
                if isGoalDone {
                    VStack(spacing: 20) {
                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentOrange)
                            .padding(.top, 30)

                        Text("Well done!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)

                        Text("Goal completed! Start learning again or set a new learning goal.")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondaryText)
                            .padding(.horizontal, 20)

                        // زر إنشاء هدف جديد
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

                        // زر نفس الهدف
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
                    // ✅ الوضع الطبيعي أثناء التعلم
                    MainActionButton(manager: manager)
                    SecondaryActionButtonView(manager: manager, maxFreezes: maxFreezes)
                    Text("\(manager.currentGoalFreezed) out of \(maxFreezes) Freezes used")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
        }
        .tint(.accentOrange)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Activity")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
            }

            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 15) {
                    NavigationLink(destination: AllActivity().environmentObject(manager)) {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .padding(4)
                    }

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
            .environmentObject(ActivityManager())
    }
}
