import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @Binding var selectedDate: Date
    @Query private var tasks: [AcademicTask]
    
    // Generate dates for the current week centered around selected date
    private var weekDates: [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        for i in -3...3 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedDate) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Today") {
                    withAnimation {
                        selectedDate = Date()
                    }
                }
                .font(.subheadline.bold())
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(weekDates, id: \.self) { date in
                        dayCell(date: date)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
    }
    
    private func dayCell(date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let isToday = Calendar.current.isDateInToday(date)
        let hasTasks = tasks.contains { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
        
        return VStack(spacing: 6) {
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption2.bold())
                .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 20, weight: isSelected ? .bold : .medium, design: .rounded))
                .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))
            
            Circle()
                .fill(hasTasks ? Color.orange : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(width: 50, height: 65)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.blue.gradient : Color.secondary.opacity(0.1).gradient)
        )
        .onTapGesture {
            withAnimation {
                selectedDate = date
            }
        }
    }
}
