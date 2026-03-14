import Foundation
import SwiftData

@Model
class AcademicTask {
    var title: String
    var taskDescription: String
    
    // Impact, Confidence, Ease scores: 1 to 10
    var impact: Int
    var confidence: Int
    var ease: Int
    
    var dueDate: Date
    var isCompleted: Bool
    var creationDate: Date
    
    // Priority Score: IMPACT x CONFIDENCE x EASE
    var priorityScore: Int {
        return impact * confidence * ease
    }
    
    init(title: String, taskDescription: String, impact: Int, confidence: Int, ease: Int, dueDate: Date, isCompleted: Bool = false) {
        self.title = title
        self.taskDescription = taskDescription
        self.impact = impact
        self.confidence = confidence
        self.ease = ease
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.creationDate = Date()
    }
}
