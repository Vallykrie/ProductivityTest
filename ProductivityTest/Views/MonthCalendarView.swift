import SwiftUI
import SwiftData

struct MonthCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [AcademicTask]
    
    @State private var selectedDate: Date = Date()
    @State private var showingAddSheet = false
    
    // Helper to get days in month
    private var daysInMonth: [Date] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        var days: [Date] = []
        var currentDate = interval.start
        while currentDate < interval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return days
    }
    
    private var tasksForSelectedDate: [AcademicTask] {
        tasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
            .sorted { $0.priorityScore > $1.priorityScore }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.indigo.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Month Calendar Header
                    calendarHeader
                    
                    // Task List for Selected Date
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            Text(selectedDate.formatted(date: .complete, time: .omitted))
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            if tasksForSelectedDate.isEmpty {
                                ContentUnavailableView(
                                    "No tasks due",
                                    systemImage: "calendar.badge.clock",
                                    description: Text("You have a free day!")
                                )
                                .padding(.top, 40)
                            } else {
                                ForEach(tasksForSelectedDate) { task in
                                    TaskRowView(task: task)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTaskView()
                    .presentationDetents([.large])
                    .presentationCornerRadius(30)
            }
        }
    }
    
    private var calendarHeader: some View {
        VStack {
            // Month + Year Pager
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                Spacer()
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.title2.bold())
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .padding()
            
            // Days of week symbols
            HStack {
                ForEach(Calendar.current.veryShortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Grid
            let days = daysInMonth
            let firstDayIndex = Calendar.current.component(.weekday, from: days.first!) - 1
            let totalSlots = days.count + firstDayIndex
            let rows = Int(ceil(Double(totalSlots) / 7.0))
            
            VStack(spacing: 8) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { col in
                            let index = row * 7 + col
                            if index >= firstDayIndex && index < totalSlots {
                                let date = days[index - firstDayIndex]
                                dayCell(date: date)
                            } else {
                                Color.clear.frame(maxWidth: .infinity, minHeight: 40)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        )
        .padding()
    }
    
    private func dayCell(date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let isToday = Calendar.current.isDateInToday(date)
        let hasTasks = tasks.contains { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
        
        return VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular, design: .rounded))
                .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                )
            
            Circle()
                .fill(hasTasks ? Color.orange : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            withAnimation {
                selectedDate = date
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) {
            withAnimation {
                selectedDate = newDate
            }
        }
    }
}

#Preview {
    MonthCalendarView()
        .modelContainer(for: AcademicTask.self, inMemory: true)
}
