import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var taskDescription: String = ""
    @State private var impact: Double = 5
    @State private var confidence: Double = 5
    @State private var ease: Double = 5
    @State private var dueDate: Date = Date().addingTimeInterval(86400) // Tomorrow
    
    // Computed preview of the score
    private var currentScore: Int {
        Int(impact) * Int(confidence) * Int(ease)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Score Preview Header
                        VStack {
                            Text("\(currentScore)")
                                .font(.system(size: 60, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            Text("Priority Score Preview")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        
                        // Details Section
                        VStack(spacing: 16) {
                            TextField("Task Title", text: $title)
                                .font(.title3)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            TextField("Description", text: $taskDescription, axis: .vertical)
                                .lineLimit(3...6)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(.horizontal)
                        
                        // ICE Metrics Section
                        VStack(spacing: 24) {
                            Text("ICE Evaluation")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            MetricSlider(title: "Impact", explanation: "How much will this affect the goal?", value: $impact)
                            MetricSlider(title: "Confidence", explanation: "How sure are you it will work?", value: $confidence)
                            MetricSlider(title: "Ease", explanation: "How easy is this to do?", value: $ease)
                        }
                        .padding(.vertical)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                    }
                    .fontWeight(.bold)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let newTask = AcademicTask(
            title: title,
            taskDescription: taskDescription,
            impact: Int(impact),
            confidence: Int(confidence),
            ease: Int(ease),
            dueDate: dueDate
        )
        modelContext.insert(newTask)
        dismiss()
    }
}

struct MetricSlider: View {
    let title: String
    let explanation: String
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(Int(value)) / 10")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.blue)
            }
            
            Text(explanation)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Slider(value: $value, in: 1...10, step: 1)
                .tint(.blue)
        }
        .padding(.horizontal, 24)
    }
}
