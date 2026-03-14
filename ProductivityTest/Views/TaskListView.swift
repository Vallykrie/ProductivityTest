import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable {
    case priority = "Priority Score"
    case creation = "Recently Added"
}

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [AcademicTask]
    
    @State private var showingAddSheet = false
    @State private var sortOption: SortOption = .priority
    @State private var showCompleted = false
    @State private var selectedDate: Date = Date()
    
    // In-memory sorting and filtering
    private var filteredAndSortedTasks: [AcademicTask] {
        let dateFiltered = tasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
        let statusFiltered = dateFiltered.filter { showCompleted ? true : !$0.isCompleted }
        
        return statusFiltered.sorted { task1, task2 in
            switch sortOption {
            case .priority:
                return task1.priorityScore > task2.priorityScore
            case .creation:
                return task1.creationDate > task2.creationDate
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Vibrant background
                LinearGradient(
                    colors: [Color.indigo.opacity(0.15), Color.purple.opacity(0.15), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CalendarHeaderView(selectedDate: $selectedDate)
                    
                    if tasks.isEmpty {
                        ContentUnavailableView(
                            "No Tasks Yet",
                            systemImage: "checklist.checked",
                            description: Text("Add your first academic task to get started based on the ICE formula.")
                        )
                    } else if filteredAndSortedTasks.isEmpty {
                        ContentUnavailableView(
                            "No Tasks for this date",
                            systemImage: "calendar.badge.clock",
                            description: Text("You have a free day! Or select another day from the calendar.")
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredAndSortedTasks) { task in
                                    TaskRowView(task: task)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                modelContext.delete(task)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        
                        Divider()
                        
                        Toggle("Show Completed", isOn: $showCompleted)
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showingAddSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                            Text("New Task")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTaskView()
                    .presentationDetents([.large])
                    .presentationCornerRadius(30)
            }
        }
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: AcademicTask.self, inMemory: true)
}
