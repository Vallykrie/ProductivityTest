import SwiftUI
import SwiftData

struct TaskRowView: View {
    let task: AcademicTask
    
    var body: some View {
        HStack(spacing: 16) {
            // ICE Score Badge
            VStack {
                Text("\(task.priorityScore)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("ICE Pts")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 70, height: 70)
            .background(
                Circle()
                    .fill(scoreColor(for: task.priorityScore).gradient)
                    .shadow(color: scoreColor(for: task.priorityScore).opacity(0.5), radius: 8, x: 0, y: 5)
            )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .strikethrough(task.isCompleted, color: .primary)
                
                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Image(systemName: "calendar")
                    Text(task.dueDate, style: .date)
                }
                .font(.caption)
                .foregroundColor(dueDateColor(for: task.dueDate))
                .padding(.top, 2)
            }
            
            Spacer()
            
            // Completion Checkmark
            Button(action: {
                withAnimation {
                    task.isCompleted.toggle()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
        // Add a subtle border for enhanced glassmorphic effect
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // Helper to determine badge color based on priority
    private func scoreColor(for score: Int) -> Color {
        switch score {
        case 0...200: return .blue
        case 201...500: return .orange
        case 501...1000: return .red
        default: return .gray
        }
    }
    
    // Helper for due date color (red if past due, else secondary)
    private func dueDateColor(for date: Date) -> Color {
        if date < Date() && !task.isCompleted {
            return .red
        }
        return .secondary
    }
}
