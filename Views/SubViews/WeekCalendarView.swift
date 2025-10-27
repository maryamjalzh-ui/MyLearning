import SwiftUI

// MARK: - WeekCalendarView
// Displays a horizontal weekly calendar with navigation between weeks
struct WeekCalendarView: View {
    @ObservedObject var manager: ActivityManager        // Observes activity and week state
    @State private var isShowingDatePicker = false      // Controls visibility of the date picker sheet
    @State private var tempDate = Date()                // Temporary date used in picker before confirmation
    
    // Formats the current week’s month and year for display (e.g., "October 2025")
    var monthYearDisplay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: manager.startOfWeek).capitalized
    }
    
    // Returns an array of 7 dates (the current week)
    func getWeekDays() -> [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: manager.startOfWeek) }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Header with Month and Week Navigation
            HStack {
                // Month and Year display + calendar picker button
                HStack(spacing: 6) {
                    Text(monthYearDisplay)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    
                    // Button to show date picker
                    Button(action: {
                        tempDate = manager.startOfWeek
                        isShowingDatePicker.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.accentOrange)
                    }
                }
                
                Spacer()
                
                // MARK: - Previous Week Button
                Button {
                    if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: manager.startOfWeek) {
                        manager.startOfWeek = newDate
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.accentOrange)
                        .padding(15)
                }
                
                // MARK: - Next Week Button
                Button {
                    if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: manager.startOfWeek) {
                        manager.startOfWeek = newDate
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.accentOrange)
                }
            }
            
            // MARK: - Date Picker Sheet
            .sheet(isPresented: $isShowingDatePicker) {
                VStack {
                    // Wheel-style date picker to jump to another week
                    DatePicker("Select Date", selection: $tempDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .accentColor(.accentOrange)
                        .padding()
                    
                    // Confirmation button to apply chosen date
                    Button("Done") {
                        if let newStart = tempDate.startOfWeek {
                            manager.startOfWeek = newStart
                        }
                        isShowingDatePicker = false
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentOrange)
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .presentationDetents([.height(300)]) // Limit popup height
                .background(Color.primaryBackground)
            }
            
            // MARK: - Week Days Row
            HStack(spacing: 0) {
                ForEach(getWeekDays(), id: \.self) { date in
                    DateButton(manager: manager, date: date)
                        .frame(maxWidth: .infinity) // Equal spacing across days
                }
            }
            
            // MARK: - Divider Line
            Divider()
                .frame(height: 0.5)
                .background(Color.gray.opacity(0.2))
                .padding(.horizontal, 10)
        }
    }
}

// MARK: - Preview
#Preview {
    WeekCalendarView(manager: ActivityManager())
}
