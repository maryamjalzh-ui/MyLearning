import SwiftUI

struct WeekCalendarView: View {
    @ObservedObject var manager: ActivityManager
    @State private var isShowingDatePicker = false
    @State private var tempDate = Date()
    
    var monthYearDisplay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: manager.startOfWeek).capitalized
    }
    
    func getWeekDays() -> [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: manager.startOfWeek) }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                HStack(spacing: 6) {
                    Text(monthYearDisplay)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    
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
            .sheet(isPresented: $isShowingDatePicker) {
                VStack {
                    DatePicker("Select Date", selection: $tempDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .accentColor(.accentOrange)
                        .padding()
                    
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
                .presentationDetents([.height(300)])
                .background(Color.primaryBackground)
            }
            
            HStack(spacing: 0) {
                ForEach(getWeekDays(), id: \.self) { date in
                    DateButton(manager: manager, date: date)
                        .frame(maxWidth: .infinity)
                }
            }
            
            Divider()
                .frame(height: 0.5)
                .background(Color.gray.opacity(0.2))
                .padding(.horizontal, 10)
        }
    }
}

#Preview {
    WeekCalendarView(manager: ActivityManager())
}
